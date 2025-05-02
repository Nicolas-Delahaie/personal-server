# Services et configurations pour le serveur personnel

Explications de la mise en place d'un serveur perso et codes divers. Dans mon cas, j'utilise un "Shuttle" (ordinateur compact) en Debian.

## Installation

Pour lancer le projet, créer un fichier `.env` avec les variables suivantes :

1. `DOMAIN` : hôte
2. `TRAEFIK_USER` : utilisateur pour l'authentification de traefik
3. `TRAEFIK_PASSWORD` : mot de passe pour l'authentification de traefik

Ensuite, exécuter :

```bash
docker compose up -d --build
```

## Configuration de Portainer

Le premier lancement de Portainer ne doit surtout pas être fait en public. En effet, celui-ci a absolument besoins d'être lancé en local au premier lancement pour configurer les identifiants depuis l'interface.

Pour ce faire :

1. Être sur le même réseau physique que le Shuttle
2. Modifier le service "portainer" dans `compose.yml`:

   1. Ouvrir temporairement un port local :

      ```yml
      ports:
        - 127.0.0.1:80:9000
      ```

   2. Désactiver temporairement Traefik :

      ```yml
      labels:
        - "traefik.enable=false"
      ```

3. `docker compose up portainer`
4. Configurer le mot de passe via l'interface http.
5. Annuler les modifications du `compose.yml`.
6. Le compte admin est configuré !

Tant que le volume partagé Docker n'est pas supprimé, les identifiants seront gardés, alors aucuns soucis à se faire aux redémarrages et rebuilds des conteneurs.

## Développement

Pour les modifications nécessitant le re lancement des conteneurs et des tests, je recommande de développer directement dans le shuttle, notamment via l'extension VSCode `ms-vscode-remote.remote-ssh`. Ensuite lorsque la modification fonctionne, copier coller et comiter en local. De cette manière, pas besoins de modifier-commit-push-pull-tester à chaque modification du code.

Je recommande aussi de faire attention à garder les modifications effectives sois en local, sois sur la Shuttle pour ne pas s'emmêler les pinceaux.
