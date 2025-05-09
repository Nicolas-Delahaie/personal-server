# Configuration de **dnsmasq**

Dnsmasq est un serveur DNS et DHCP léger, souvent utilisé pour gérer les adresses IP sur un réseau local.

## Configuration du DHCP

Ce serveur DNS sert à attribuer dynamiquement une adresse au Shuttle, afin de pouvoir s'y connecter de manière locale pour du débogage. Sans ce serveur, il faudrait configurer manuellement son adresse.

1. **Identifier l'interface Ethernet du Mac**

   - Lire l’adresse MAC directement sur l’adaptateur Ethernet utilisé.
   - Utiliser `ip a` pour retrouver l’interface associée et repérer son adresse IPv4 (champ `inet`) correspondant à cette adresse MAC.

2. **Configurer dnsmasq sur Mac**

   - Installation : `brew install dnsmasq`
   - Ajouter dans `/opt/homebrew/etc/dnsmasq.conf` :

     ```ini
     # Permet de se déclarer comme unique serveur DHCP sur le réseau
     dhcp-authoritative
     # Configure l'interface à écouter, la plage, le masque et la durée de bail
     dhcp-range=en11,192.168.10.50,192.168.10.150,255.255.255.0,24h
     # Définir la passerelle par défaut (l'adresse IP du Mac)
     dhcp-option=en11,3,192.168.10.1
     ```

     > Attention, l'IP de départ de la plage doit être supérieure à l'IP statique du Mac
     > Note : La plage 192.168.10.x est recommandée, car réservée aux réseaux privés et peu utilisée par défaut, évitant ainsi les conflits.

   - Redémarrer le service :

     ```bash
     sudo brew services restart dnsmasq
     ```

   - Pour du débogage en temps réel, on peut stopper le service et lancer `dnsmasq` manuellement :

     ```bash
     sudo dnsmasq --no-daemon --log-dhcp
     ```

3. **Configurer manuellement l'IP du Mac sur son interface Ethernet**

   - Configurer l'IP statique dans "Réglages" > "Réseau" > nom de l'adaptateur ethernet > "TCP/IP" > "Configurer IPv4" : Manuellement
   - Adresse IP : 192.168.10.1 (doit correspondre à la gateway définie dans dhcp-option)
   - Masque : 255.255.255.0

4. **Configurer le Shuttle comme client DHCP**
   - Activer le client DHCP sur l’interface réseau du Shuttle correspondant au port Ethernet utilisé.
   - Connecter le câble Ethernet entre le Mac et le Shuttle.
   - Une fois branché, le Shuttle devrait automatiquement demander une IP au Mac (via `dnsmasq`).
   - Les logs du `dnsmasq` en mode synchrone permettent de voir les requêtes DHCP entrantes et de diagnostiquer les éventuelles erreurs d’attribution.
   - Se référer à la section "[débogage](#débogage)" pour plus de détails.

## Configuration du DNS

Traefik génère des sous domaines pour chaque service. Cela fonctionne car au niveau du DNS global, tous les sous domaines redirigent vers la même IP. Cependant en localhost, il ne sait pas que \*.localhost doit être redirigé vers localhost.

Le serveur DNS a pour but de rediriger tous les sous domaines locaux de localhost vers lui-même. Cela permet de tester l'application en local, dans les mêmes conditions, avant d'envoyer en production sur le Shuttle. Celui-ci possède déjà cette redirection, mais au niveau du DNS global.

Autrement, il faudrait mapper les ports dans le docker compose pour utiliser les services sans passer par sous domaine.

## Débogage

Ajouter les lignes suivantes dans le fichier de configuration `/opt/homebrew/etc/dnsmasq.conf` pour activer le débogage :

```ini
log-queries
log-facility=/opt/homebrew/var/log/dnsmasq.log
```

On peut ensuite visualiser les logs avec `tail -f /opt/homebrew/var/log/dnsmasq.log` pour voir les requêtes DNS et DHCP en temps réel.
