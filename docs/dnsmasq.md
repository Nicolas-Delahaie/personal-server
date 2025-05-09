# Configuration de **dnsmasq**

Dnsmasq est un serveur DNS et DHCP léger, souvent utilisé pour gérer les adresses IP sur un réseau local.

## Installation de dnsmasq

Sur la machine hôte (exemple avec Homebrew sur macOS) :

```bash
brew install dnsmasq
```

Une configuration par défaut de `dnsmasq` existe dans `configs/dnsmasq-example.conf`. Il est recommandé de l'utiliser comme base pour la configuration :

```bash
cp configs/dnsmasq-example.conf /opt/homebrew/etc/dnsmasq.conf
```

## Configuration du DHCP

Ce serveur DNS attribue dynamiquement une adresse au serveur, pour pouvoir s'y connecter de manière locale pour du débogage. La machine hôte agit alors comme une boxe internet, et le serveur peut s'y connecter de manière autonome, sans configuration supplémentaire.

1. **Configurer dnsmasq sur la machine hôte**

   - Ajouter dans `/opt/homebrew/etc/dnsmasq.conf` (sur MacOS) :

     ```ini
     # Permet de se déclarer comme unique serveur DHCP sur le réseau
     dhcp-authoritative
     # Configure l'interface à écouter, la plage, le masque et la durée de bail
     dhcp-range=192.168.10.50,192.168.10.150,255.255.255.0,24h
     # Définir la passerelle par défaut (l'adresse IP de la machine hôte)
     dhcp-option=3,192.168.10.1
     ```

     > Attention, l'IP de départ de la plage doit être supérieure à l'IP statique de la machine hôte.  
     > Attention, dnsmasq devient serveur DHCP pour toutes les interfaces. On peut préfixer dhcp-range et dhcp-option par l'interface exclusive souhaitée. Exemple `dhcp-option=en11,3,192.168.10.1`  
     > Note : La plage 192.168.10.x est recommandée, car réservée aux réseaux privés et peu utilisée par défaut, évitant ainsi les conflits.

   - Redémarrer le service :

     ```bash
     sudo brew services restart dnsmasq
     ```

2. **Configurer l'IP statique de l'interface Ethernet sur l'hôte**

   - Sur Mac dans "Réglages" > "Réseau" > nom de l'adaptateur ethernet > "TCP/IP" > "Configurer IPv4" : Manuellement
   - Adresse IP : 192.168.10.1 (doit correspondre à la gateway définie dans dhcp-option)
   - Masque : 255.255.255.0

3. **Configurer le serveur comme client DHCP**

   - Vérifier que le serveur est configuré pour utiliser le DHCP.
   - Avec `NetworkManager` :

     ```bash
     sudo nmtui
     ```

   - "Modifier une connexion"
   - Sélectionner la connexion Ethernet > "Modifier"
   - Vérifier que l'option "Configuration IPV4" est sur "Automatique" (DHCP)

4. **Connexion**
   - Connecter le câble Ethernet entre la machine hôte et le serveur.
   - Une fois branché, le serveur devrait automatiquement demander une IP à la machine hôte (via `dnsmasq`).
   - Se référer à la section "[débogage](#débogage)" pour vérifier le bon fonctionnement.

## Configuration du DNS

Traefik génère des sous domaines pour chaque service. Cela fonctionne car au niveau du DNS global, tous les sous domaines redirigent vers la même IP. Cependant en localhost, il ne sait pas que \*.localhost doit être redirigé vers localhost.

Le serveur DNS a pour but de rediriger tous les sous domaines locaux de localhost vers lui-même. Cela permet de tester l'application en local, dans les mêmes conditions, avant d'envoyer en production sur le serveur. Celui-ci possède déjà cette redirection, mais au niveau du DNS global.

Autrement, il faudrait mapper les ports dans le docker compose pour utiliser les services sans passer par sous domaine.

## Débogage

Ajouter les lignes suivantes dans le fichier de configuration `/opt/homebrew/etc/dnsmasq.conf` pour activer le débogage :

```ini
log-queries
log-facility=/opt/homebrew/var/log/dnsmasq.log
```

On peut ensuite visualiser les requêtes DNS et DHCP en temps réel avec :

```bash
tail -f /opt/homebrew/var/log/dnsmasq.log
```
