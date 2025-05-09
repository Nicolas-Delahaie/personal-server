# Configuration SSH

Le SSH (Secure Shell) est un protocole permettant de prendre le contrôle à distance du serveur de manière sécurisée. Il offre deux modes d'accès :

- En réseau local : connexion directe via l'adresse IP locale
- Depuis l'extérieur : nécessite une redirection de port sur la box internet

Bien que l'utilisation d'un VPN soit possible, le SSH a été choisi pour sa simplicité de mise en place. Cependant, comme le service est exposé à Internet, il est essentiel de le sécuriser correctement pour prévenir tout accès non autorisé.

## Protection contre les attaques par force brute

Installation de fail2ban pour bloquer les tentatives de connexion malveillantes :

```bash
sudo apt install fail2ban
```

## Création et enregistrement de la clé SSH

Avant de désactiver l'authentification par mot de passe, il est essentiel de configurer une clé SSH :

```bash
# Sur votre machine locale
ssh-keygen -t ed25519 -C "votre_email"  # Création de la clé
ssh-copy-id user_name@server           # Copie de la clé sur le serveur
```

## Sécurisation

Configuration sécurisée du serveur SSH :

1. Surcharger la configuration SSH : `sudo nano /etc/ssh/sshd_config.d/custom-config.conf` avec le contenu suivant :

   ```conf
   PermitRootLogin no
   MaxAuthTries 3
   PubkeyAuthentication yes
   X11Forwarding no
   AllowUsers votre_utilisateur

   # Une fois la clé SSH testée, ajouter :
   PasswordAuthentication no
   ChallengeResponseAuthentication no
   ```

2. Redémarrer le service SSH : `sudo systemctl restart sshd`
3. Tester la connexion avec la clé SSH avant de désactiver l'authentification par mot de passe
4. Une fois la connexion par clé confirmée, décomenter les deux dernières lignes et redémarrer SSH

## Configuration de la redirection de port

1. Accéder à l'interface de configuration de la box internet
2. Dans la section NAT/PAT, ajouter une redirection :
   - Port externe : 22
   - IP destination : IP locale du serveur
   - Port interne : 22 (même que dans sshd_config)

## Simplification de la connexion

Pour se connecter sans préciser l'utilisateur à chaque fois, configurer le fichier SSH local :

1. Créer ou éditer le fichier de configuration :

   ```bash
   nano ~/.ssh/config
   ```

2. Ajouter la configuration :

   ```conf
    Host shuttle shuttle.local nicolas-delahaie.fr 64.64.31.31
        User patate
   ```

Désormais, la connexion se fait simplement avec :

```bash
ssh server.local
```
