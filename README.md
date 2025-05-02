# Services et configurations pour le serveur personnel

Explications de la mise en place d'un serveur perso et codes divers. Dans mon cas, j'utilise un "Shuttle" (ordinateur compact) en Debian.

## Installation

Pour lancer le projet, créer un fichier `.env` avec les variables suivantes :

1. `HOSTNAME`
2. `PORTAINER_ADMIN_PASSWORD`
3. `TRAEFIK_USER`
4. `TRAEFIK_PASSWORD`

Ensuite, exécuter :

```bash
docker compose up -d --build
```

## Configuration de Portainer

Le mot de passe de Portainer au premier lancement sera celui défini dans la variable `PORTAINER_ADMIN_PASSWORD`.

En cas de modification de mot de passe, 2 possibilités :

1. Au niveau du code :
   1. Éteindre le conteneur, en supprimant ses données : `docker compose down portainer -v` (-v pour supprimer son volume)
   2. Modifier la variable : `PORTAINER_ADMIN_PASSWORD`
   3. Relancer : `docker compose up portainer -d --build`
2. Sur l'interface graphique
   1. `Admin` en haut à droite
   2. `My account`
   3. `Change user password`
   4. Attention, avec cette méthode on perd la trace du nouveau mot de passe dans le code

## Développement

Pour les modifications nécessitant le re lancement des conteneurs et des tests, je recommande de développer directement dans le shuttle, notamment via l'extension VSCode `ms-vscode-remote.remote-ssh`. Ensuite lorsque la modification fonctionne, copier coller et comiter en local. De cette manière, pas besoins de modifier-commit-push-pull-tester à chaque modification du code.

Je recommande aussi de faire attention à garder les modifications effectives sois en local, sois sur la Shuttle pour ne pas s'emmêler les pinceaux.
