# Services et configurations pour le serveur personnel

Inclue notamment les outils de monitoring ou de routage.

## Configuration portainer

!! ATTENTION !!

Le premier lancement de Portainer ne doit surtout pas être fait en public. En effet, celui-ci a absolument besoins d'être lancé en local au premier lancement pour configurer les identifiants depuis l'interface.

Pour ce faire :

1. Dans le `compose.yml`, changer le port `9000:9000` en `127.0.0.1:9000:9000` pour lancer en local
2. `docker compose up portainer
3. Configurer le mot de passe via l'interface
4. Dans le `compose.yml`, remettre `127.0.0.1:9000:9000` en `9000:9000`
5. Le compte admin est configuré !
