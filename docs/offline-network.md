# Configuration d'un réseau privé

Grâce à cette configuration, il est possible de se connecter au serveur grâce à un simple câble ethernet, sans avoir besoin de passer par la box internet. Cela permet de le déboguer sans dépendre de la connexion internet.

## Partage internet

Consiste à partager la connexion internet de la machine hôte au serveur, afin de le lier au même réseau. Cependant cette solution ne permet pas une réelle isolation en réseau local exclusif.

Sur la machine hôte :

1. Sur MacOS : Paramètres > Partage Internet
2. Source : connexion internet à partager (ex: wifi)
3. Destination : port utilisé pour l'ethernet

## Protocole APIPA

Lorsque aucun protocole DHCP n'est configuré, il est possible de se connecter au serveur via le protocole APIPA (Automatic Private IP Addressing). Ce protocole permet d'attribuer automatiquement une adresse IP à un appareil lorsqu'il ne peut pas obtenir d'adresse IP via DHCP. Cela fonctionne sur les réseaux locaux.

Sur le serveur :

1. `sudo nmtui`
2. "Modifier une connexion"
3. Choisir l'interface Ethernet
4. Configurer IPV4 : "Lien local" (APIPA)

Sur la machine hôte (déjà configuré par défaut) :

1. Sur MacOS : Paramètres > Réseau
2. Choisir l'interface Ethernet
3. Détails > TCP/IP
4. S'assurer que IPV4 est en "via DHCP" (pour qu'il cherche le serveur DHCP inexistant et tombe en APIPA)

Connecter le serveur à la machine hôte via un câble Ethernet. Les deux appareils devraient s'auto-attribuer une adresse IP dans la plage 169.254.x.x. La connexion deviendra alors active.

## Serveur DHCP sur hôte

Pour configurer un serveur DHCP sur la machine hôte, il existe notamment le service `dnsmasq`. Sa configuration est présente [ici](./dnsmasq.md#configuration-du-dhcp).
