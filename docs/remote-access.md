# Configuration SSH

Le SSH (Secure Shell) est un protocole permettant le contrôle à distance sécurisé du serveur. Deux modes d'accès disponibles :

- Réseau local : connexion directe via l'adresse IP locale
- Accès externe : nécessite une redirection de port sur la box internet

Bien que l'utilisation d'un VPN soit possible, le SSH est privilégié pour sa simplicité de mise en place. L'exposition du service à Internet nécessite une sécurisation appropriée.

## Configuration des clés SSH

1. Générer une clé SSH sur la machine locale :

   ```bash
   ssh-keygen -t ed25519 -C "server-access"
   ```

   > **Sécurité : toujours définir une passphrase.** Sans passphrase, la clé privée est en clair sur le disque. En cas de vol ou de compromission de la machine cliente, un attaquant pourra se connecter directement au serveur. La passphrase chiffre la clé privée localement — même si le fichier est volé, il est inutilisable sans elle.
   > Pour ajouter une passphrase à une clé existante : `ssh-keygen -p -f ~/.ssh/id_ed25519`

2. Copier la clé sur le serveur :

   ```bash
   ssh-copy-id user_name@server
   ```

3. Pour ne pas avoir à ressaisir la passphrase à chaque connexion, la stocker dans un gestionnaire de clés :

   **macOS (Keychain + TouchID) :**

   Ajouter dans `~/.ssh/config` :

   ```conf
   Host *
         AddKeysToAgent yes
         UseKeychain yes
   ```

   Puis enregistrer la clé dans le Keychain :

   ```bash
   ssh-add --apple-use-keychain ~/.ssh/id_ed25519
   ```

   La passphrase sera déverrouillée automatiquement avec la session macOS (TouchID / mot de passe de session). Session verrouillée = clé inaccessible.

## Sécurisation du serveur

1. Modifier la configuration SSH :

   ```bash
   sudo nano /etc/ssh/sshd_config.d/custom-config.conf
   ```

2. Ajouter les paramètres de sécurité :

   ```conf
   LoginGraceTime 1m
   PermitRootLogin no
   MaxAuthTries 3
   PubkeyAuthentication yes
   X11Forwarding no
   AllowUsers votre_utilisateur

   # Une fois la clé SSH testée, ajouter :
   PasswordAuthentication no
   ChallengeResponseAuthentication no
   ```

3. Redémarrer le service SSH :

   ```bash
   sudo systemctl restart sshd
   ```

4. Tester la connexion par clé avec `ssh user_name@server.local`.
5. Après validation de la connexion, dé-commenter les deux dernières lignes et redémarrer SSH.

## Simplification de la connexion

Pour éviter de spécifier l'utilisateur à chaque connexion, ajouter au fichier `~/.ssh/config` :

```conf
Host shuttle shuttle.local nicolas-delahaie.fr 64.64.31.31
      User user_name
```

La connexion devient alors possible via :

```bash
ssh server.local
```

## Redirection du port 22

Une fois le SSH configuré, il est nécessaire de rediriger le port 22 du serveur sur la box. Pour cela, suivre la procédure [ici](./router-setup.md#redirection-des-ports) et s'assurer que les règles de pare-feu permettent l'accès au port 22.

## Tunnel Ollama (Mac)

Permet d'exposer l'Ollama d'un Mac (Apple Silicon) au Open WebUI du serveur via un tunnel SSH reverse. Les modèles du Mac apparaissent dans Open WebUI en plus des modèles locaux du serveur.

### Prérequis

- Le Mac doit avoir accès SSH au serveur
- Ollama doit tourner sur le Mac (port 11434)
- L'option **"Exposer Ollama to the network"** doit être activée dans les réglages d'Ollama. Sans cette option, Ollama rejette les requêtes provenant du tunnel avec une erreur 403.

> **⚠️ Avertissement de sécurité** : activer l'accès réseau fait écouter Ollama sur **toutes les interfaces réseau** du Mac, y compris les réseaux wifi publics. N'importe qui sur le même réseau peut alors accéder à l'API Ollama et :
>
> - utiliser le CPU/GPU du Mac pour ses propres prompts (vol de puissance de calcul)
> - lister, supprimer ou injecter des modèles
>
> En revanche, **les conversations Open WebUI ne sont pas exposées** : Ollama est stateless, l'historique est stocké côté Open WebUI sur le Shuttle.
>
> **Pourquoi pas mieux ?** Ollama hardcode les hôtes acceptés (`localhost`, `127.0.0.1`) dans son check anti-DNS-rebinding sur le header HTTP `Host`, et ne fournit pas de variable d'environnement pour étendre cette liste. `OLLAMA_ORIGINS` ne contrôle que CORS (header `Origin` des navigateurs), pas ce check. Les alternatives propres (firewall pf, mini proxy local de réécriture du `Host`) ont été écartées pour leur complexité de mise en œuvre et de maintenance.

### Configuration serveur SSH

Ajouter dans la config sshd (ex : `/etc/ssh/sshd_config`) :

```
GatewayPorts clientspecified
ClientAliveInterval 30
ClientAliveCountMax 3
```

- `GatewayPorts clientspecified` : permet au tunnel de binder sur l'IP Docker gateway (`DOCKER_GATEWAY_IP`), nécessaire pour que les conteneurs accèdent au tunnel
- `ClientAliveInterval/CountMax` : détecte les clients SSH morts en ~90s et libère le port du tunnel. Sans ça, une déconnexion brutale du Mac (wifi, veille) laisse une session zombie qui bloque le port

Puis relancer sshd : `sudo systemctl restart sshd`

### Lancement automatique au login

Créer `~/Library/LaunchAgents/com.ollama-tunnel.plist` :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ollama-tunnel</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/ssh</string>
        <string>-N</string>
        <string>-o</string>
        <string>ServerAliveInterval=30</string>
        <string>-o</string>
        <string>ServerAliveCountMax=3</string>
        <string>-R</string>
        <string>DOCKER_GATEWAY_IP:11434:localhost:11434</string>
        <string>DOMAIN</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/ollama-tunnel.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/ollama-tunnel.log</string>
</dict>
</plist>
```

- `-N` : pas de shell distant, tunnel uniquement
- `ServerAliveInterval/CountMax` : détecte une connexion morte en ~90s côté client
- Le tunnel bind sur l'IP Docker gateway pour être accessible depuis les conteneurs
- `RunAtLoad` / `KeepAlive` : lance le tunnel au login et le redémarre automatiquement s'il meurt — le binaire `ssh` natif suffit, pas besoin d'`autossh`

Remplacer `DOCKER_GATEWAY_IP` et `DOMAIN` par les valeurs du `.env`, puis charger le plist :

```bash
launchctl load ~/Library/LaunchAgents/com.ollama-tunnel.plist
```

`RunAtLoad: true` lance le tunnel immédiatement et `KeepAlive: true` le redémarre automatiquement s'il meurt. Le binaire `ssh` natif suffit : la résilience est assurée par launchd, pas besoin d'`autossh`.

### Mise à jour ou désactivation du tunnel

`KeepAlive: true` rend `launchctl stop` inopérant : le process est immédiatement relancé. Pour modifier le plist ou désactiver le tunnel, utiliser `unload`/`load` :

```bash
# Désactiver
launchctl unload ~/Library/LaunchAgents/com.ollama-tunnel.plist

# Recharger après modification
launchctl load ~/Library/LaunchAgents/com.ollama-tunnel.plist
```

### Vérification

Sur le Mac : `launchctl list | grep ollama` doit montrer un PID (1re colonne).

Sur le serveur : `ss -tlnp | grep 11434` doit montrer le port en écoute.

Depuis l'interface Open WebUI, les modèles du Mac doivent apparaître dans la catégorie "externe".
