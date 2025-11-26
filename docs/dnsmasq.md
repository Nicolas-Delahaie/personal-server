# Configuration de **dnsmasq**

Dnsmasq est un serveur DNS et DHCP léger, souvent utilisé pour gérer les adresses IP sur un réseau local.

## Installation de dnsmasq

Sur la machine hôte (exemple avec Homebrew sur macOS) :

```bash
brew install dnsmasq
```

Une configuration par défaut de `dnsmasq` est disponible dans `host_configs/dnsmasq-example.conf`. Pour l'utiliser comme base :

```bash
cp host_configs/dnsmasq-example.conf /opt/homebrew/etc/dnsmasq.conf
```

## Configuration du DHCP

Ce serveur DNS attribue dynamiquement une adresse au serveur, permettant une connexion locale pour le débogage. La machine hôte agit comme une box internet et le serveur peut s'y connecter de manière autonome.

1. **Configuration de dnsmasq sur la machine hôte**

   - Dans `/opt/homebrew/etc/dnsmasq.conf` (chemin sur MacOS), ajouter :

     ```ini
     # Permet de se déclarer comme unique serveur DHCP sur le réseau
     dhcp-authoritative
     # Configure l'interface à écouter, la plage, le masque et la durée de bail
     dhcp-range=192.168.10.50,192.168.10.150,255.255.255.0,24h
     # Définir la passerelle par défaut (l'adresse IP de la machine hôte)
     dhcp-option=3,192.168.10.1
     # Réponses DNS limitées aux réseaux locaux
     local-service
     ```

     > Notes importantes :
     >
     > - L'IP de départ doit être supérieure à l'IP statique de la machine hôte
     > - Dnsmasq devient serveur DHCP pour toutes les interfaces
     > - Pour limiter à une interface spécifique, préfixer avec son nom (exemple : `dhcp-option=en11,3,192.168.10.1`)
     > - La plage 192.168.10.x est recommandée car réservée aux réseaux privés et peu utilisée

   - Redémarrer le service :

     ```bash
     sudo brew services restart dnsmasq
     ```

2. **Configuration IP statique sur l'interface Ethernet de l'hôte**

   - Dans Réglages > Réseau > adaptateur ethernet > TCP/IP :
     - Configurer IPv4 : Manuellement
     - Adresse IP : 192.168.10.1 (correspondant à la gateway dans dhcp-option)
     - Masque : 255.255.255.0

3. **Configuration du serveur en client DHCP**

   - Configurer le serveur pour utiliser DHCP via NetworkManager :

     ```bash
     sudo nmtui
     ```

   - Sélectionner "Modifier une connexion"
   - Choisir la connexion Ethernet > "Modifier"
   - Vérifier "Configuration IPV4" sur "Automatique" (DHCP)

4. **Établissement de la connexion**
   - Connecter le câble Ethernet entre hôte et serveur
   - Le serveur recevra automatiquement une IP via dnsmasq
   - Pour vérifier, consulter la section "[débogage](#débogage)"

## Configuration du DNS

Traefik génère des sous-domaines pour chaque service. En production, tous les sous-domaines pointent vers la même IP via le DNS global. En local, il faut configurer la redirection de `*.localhost` vers `localhost`.

Le serveur DNS redirige tous les sous-domaines locaux vers lui-même, permettant de tester l'application en local dans les mêmes conditions qu'en production.

Ajouter dans `/opt/homebrew/etc/dnsmasq.conf` :

```ini
address=/.localhost/127.0.0.1
```

Configuration du résolveur DNS :

```bash
sudo mkdir -p /etc/resolver
echo "nameserver 127.0.0.1" \
 | sudo tee /etc/resolver/localhost

sudo nano /opt/homebrew/etc/dnsmasq.conf
sudo nano /etc/resolv.conf
sudo nano /etc/resolver/localhost
ls /etc/resolver
```

Note : /etc/resolv.conf est généré automatiquement selon le réseau utilisé

## Débogage

### Logging

Ajouter dans `/opt/homebrew/etc/dnsmasq.conf` :

```ini
log-queries
log-facility=/opt/homebrew/var/log/dnsmasq.log
```

Visualisation en temps réel des requêtes DNS et DHCP :

```bash
tail -f /opt/homebrew/var/log/dnsmasq.log
```

Pour les erreurs de lancement (configuration invalide) :

```bash
sudo log stream --style syslog --predicate 'process == "dnsmasq"'
```

Vérification de l'écoute sur le port 53 :

```bash
sudo lsof -i UDP:53 -i TCP:53
```

### Requêtes DNS

```bash
dig <domain> +short
dig @127.0.0.1 <domain> +short
dig +trace <domain> # tracer la chaîne DNS
nslookup <domain>
```

### Informations sur le résolveur (macOS)

```bash
scutil --dns
scutil --resolver localhost
dscacheutil -q host -a name <domain>
```

### Vidage du cache DNS (macOS)

```bash
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

### Tests de connectivité

```bash
ping -c1 test.localhost
curl -I --no-keepalive http://<service>.localhost
```
