La 2e solution consiste à créer un sous réseau grâce à un serveur DHCP (dnsmasq) hébergé sur le mac. Ce serveur a pour but d'écouter les connexions entrantes sur un périphérique défini et d'adresser une adresse dynamiquement dans une plage définie à l'appareil le demandant.

1. **Identifier l'interface Ethernet du Mac**

   - Lire l’adresse MAC directement sur l’adaptateur Ethernet utilisé.
   - Utiliser `ip a` pour retrouver l’interface associée et repérer son adresse IPv4 (champ `inet`) correspondant à cette adresse MAC.

2. **Configurer dnsmasq sur le Mac**

   - Installation : `brew install dnsmasq`
   - Configuration `/opt/homebrew/etc/dnsmasq.conf` :

     ```ini
     # Nom de l'interface à écouter (identifiée précédemment)
     interface=<nom_interface>
     # Désactiver le DNS pour n'utiliser que le DHCP
     port=0
     # Configuration DHCP
     dhcp-authoritative
     dhcp-range=192.168.10.50,192.168.10.150,255.255.255.0,24h
     # Définir la passerelle par défaut (l'adresse IP du Mac)
     dhcp-option=3,192.168.10.1
     ```

   > Note : La plage 192.168.10.x est recommandée car réservée aux réseaux privés et peu utilisée par défaut, évitant ainsi les conflits.

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

4. **Configurer le Shuttle comme client DHCP**
   - Activer le client DHCP sur l’interface réseau du Shuttle correspondant au port Ethernet utilisé.
   - Connecter le câble Ethernet entre le Mac et le Shuttle.
   - Une fois branché, le Shuttle devrait automatiquement demander une IP au Mac (via `dnsmasq`).
   - Les logs du `dnsmasq` en mode synchrone permettent de voir les requêtes DHCP entrantes et de diagnostiquer les éventuelles erreurs d’attribution.

## Deboggage

1. Rebrancher l’ethernet si les parametres du Mac sont modifiés (internet partagé, wifi changé)
2. Vérifier sur le Mac dans Paramètres > Internet que la connexion apparaisse