# Configuration d'un réseau privé

Grâce à cette configuration, il est possible de se connecter au Shuttle grâce à un simple câble ethernet, sans avoir besoin de passer par la box internet. Cela permet de déboguer le Shuttle sans dépendre de la connexion internet.

## Partage internet

Consiste à partager la connexin internet de l'hôte au Shuttle, afin de le lier au même réseau. Cependant cette solution ne permet pas une réelle isolation en réseau local exclusif.

Sur MacOS :

1. Paramètres > Partage Internet
2. Source : connexion internet à partager (ex: wifi)
3. Destination : port utilisé pour l’ethernet

## Protocole APIPA

Lorsque aucun protocole DHCP n'est configuré, il est possible de se connecter au Shuttle via le protocole APIPA (Automatic Private IP Addressing). Ce protocole permet d'attribuer automatiquement une adresse IP à un appareil lorsqu'il ne peut pas obtenir d'adresse IP via DHCP. Cela fonctionne sur les réseaux locaux.

Sur le shuttle :

1. `sudo nmtui`
2. "Modifier une connexion"
3. Choisir l'interface Ethernet
4. Configurer IPV4 : "Lien local" (APIPA)

Sur le Mac (déjà par défaut):

1. Paramètres > Réseau
2. Choisir l'interface Ethernet
3. Détails > TCP/IP
4. S'assurer que IPV4 est en "via DHCP" (pour qu'il cherche le serveur DHCP inexistant et tombe en APIPA)

Connecter le Shuttle à l'ordinateur via un câble Ethernet. Les deux appareils devraient s'auto-attribuer une adresse IP dans la plage 169.254.x.x. La connexion deviendra alors active.

## Serveur DHCP sur hôte

Pour configurer un serveur DHCP sur l'hôte, il existe notamment le service `dnsmasq`. Sa configuration est présente [ici](dnsmasq-configuration.md#configuration-du-dhcp).
