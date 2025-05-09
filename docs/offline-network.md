# Configuration d'un réseau privé

Cette configuration permet la connexion au serveur via un simple câble ethernet, sans dépendre de la box internet. Idéal pour le débogage en mode local.

## Partage internet

Cette méthode permet de partager la connexion internet de la machine hôte au serveur. Note : cette solution ne permet pas une réelle isolation en réseau local exclusif.

Configuration sur la machine hôte (sur MacOS) :

1. Accéder aux Paramètres > Partage Internet
2. Sélectionner la source : connexion internet à partager (ex: wifi)
3. Définir la destination : port Ethernet utilisé

## Protocole APIPA

En l'absence de protocole DHCP, le protocole APIPA (Automatic Private IP Addressing) permet une connexion automatique. Ce protocole attribue automatiquement une adresse IP lorsqu'aucun serveur DHCP n'est disponible.

Configuration sur le serveur :

1. Exécuter `sudo nmtui`
2. Sélectionner "Modifier une connexion"
3. Choisir l'interface Ethernet
4. Configurer IPV4 en "Lien local" (APIPA)

Configuration sur la machine hôte (généralement déjà active par défaut) :

1. Accéder à Paramètres > Réseau
2. Sélectionner l'interface Ethernet
3. Dans Détails > TCP/IP
4. Configurer IPV4 en "via DHCP" (pour déclencher APIPA en l'absence de serveur DHCP)

Une fois le câble Ethernet connecté, les appareils s'attribuent automatiquement une adresse IP dans la plage 169.254.x.x et établissent la connexion.

## Serveur DHCP sur hôte

Pour configurer un serveur DHCP sur la machine hôte avec `dnsmasq`, suivre la documentation [ici](./dnsmasq.md#configuration-du-dhcp).
