# Configuration SSH

Le SSH (Secure Shell) est un protocole permettant le contrôle à distance sécurisé du serveur. Deux modes d'accès disponibles :

- Réseau local : connexion directe via l'adresse IP locale
- Accès externe : nécessite une redirection de port sur la box internet

Bien que l'utilisation d'un VPN soit possible, le SSH est privilégié pour sa simplicité de mise en place. L'exposition du service à Internet nécessite une sécurisation appropriée.

## Protection contre les attaques par force brute

Installation de fail2ban pour bloquer les tentatives de connexion malveillantes :

```bash
sudo apt install fail2ban
```

## Configuration des clés SSH

1. Générer une clé SSH sur la machine locale :

   ```bash
   ssh-keygen -t ed25519 -C "email"
   ```

2. Copier la clé sur le serveur :

   ```bash
   ssh-copy-id user_name@server
   ```

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

Une fois le SSH configuré, il est nécessaire de rediriger le port 22 de la box. Pour cela, suivre la procédure [ici](./router-setup.md#redirection-des-ports) et s'assurer que les règles de pare-feu permettent l'accès au port 22.
