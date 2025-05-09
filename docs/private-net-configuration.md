Bien que ce soit facultatif, il est préférable de configurer un accès direct au Shuttle dans le cas où la boxe internet ne fonctionnerait plus.

### Partage internet

Consiste à partager la connexin internet de l'hôte au Shuttle, afin de le lier au même réseau. Cependant cette solution ne permet pas une réelle isolation en réseau local exclusif. Sur MacOS :

1. Paramètres > Partage Internet
2. Source : connexion internet à partager (ex: wifi)
3. Destination : port utilisé pour l’ethernet

### Serveur DHCP sur hôte

La configuration d'un serveur DHCP sur l'hôte est la 2e solution. Il existe notamment le service `dnsmasq`. Sa configuration est présente [ici](dnsmasq-configuration.md#configuration-du-dhcp).
