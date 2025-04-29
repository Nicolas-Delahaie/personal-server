# Services et configurations pour le serveur personnel

Explications de la mise en place d'un serveur perso et codes divers. Dans mon cas, j'utilise un "Shuttle" (ordinateur compact) en Debian.

## Configuration de Portainer

Le premier lancement de Portainer ne doit surtout pas être fait en public. En effet, celui-ci a absolument besoins d'être lancé en local au premier lancement pour configurer les identifiants depuis l'interface.

Pour ce faire :

1. `docker compose up portainer`
2. Configurer le mot de passe via l'interface
3. Dans le `compose.yml`, remettre `127.0.0.1:9000:9000` en `9000:9000`
4. Le compte admin est configuré !

Tant que le volume partagé Docker n'est pas supprimé, les identifiants seront gardés, alors aucuns soucis à se faire aux redémarrages et rebuilds des containers.
