# Services et configurations pour le serveur personnel

Explications de la mise en place d'un serveur perso et codes divers. Dans mon cas, j'utilise un "Shuttle" (ordinateur compact) en Debian.

## Installation

Pour lancer le projet, créer un fichier `.env` avec les variables suivantes :

1. `HOSTNAME`
2. `PORTAINER_ADMIN_PASSWORD`
3. `TRAEFIK_USER`
4. `TRAEFIK_PASSWORD`
5. `ODOO_DB_USER`
6. `ODOO_DB_PASSWORD`
7. `ODOO_DATABASE_NAME`
8. `ODOO_DEFAULT_ADMIN_PASSWD`

## Configuration de Odoo

### Application vierge

Le premier lancement nécessite une manipulation pour initialiser et sécuriser la base de données. Cette étape est cruciale car elle rend public le site uniquement lorsque les identifiants ne sont plus admin:admin.

1. Ajouter dans le service odoo :

   ```yml
   labels:
     - "traefik.http.routers.odoo.middlewares=auth@docker"
   command: >
     -i base,calendar,account
     --load-language=fr_FR
     #  --without-demo=all
   ```

2. `docker compose up traefik odoo --build`
3. Attendre que l'initialisation ait terminé (logs du conteneur se stoppent)
4. Modifier identifiants :
   1. Photo de profil en haut à droite
   2. "Préférences"
   3. Section "sécurité du compte"
   4. "Modifier le mot de passe"
5. Remettre le fichier à l'origine pour exposer publiquement le site et désactiver l'initialisation
6. `docker compose up traefik odoo -d`

### Restauration de sauvegarde

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

## Sous domaines Traefik

Traefik génère des sous domaines pour chaque service. Cela fonctionne car au niveau du DNS, tous les sous domaines redirigent vers la même IP. Cependant en localhost, il ne sait pas que \*.localhost doit être redirigé vers localhost.

Ainsi, si on veut vérifier qu'un service fonctionne en local, il faut mapper son port temporairement.
