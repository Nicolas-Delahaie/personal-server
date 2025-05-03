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

## Configuration de Odoo

### Application vierge

1. Commenter/retirer services.odoo.labels
2. Ajouter dans service odoo :

   ```yml
   ports:
     - "8069:8069"
   command: >
     -d ${ODOO_DATABASE_NAME}
     -i base,calendar
     --without-demo=all
   ```

3. `docker compose up odoo -d`
4. Attendre que la page finisse de charger
5. Se connecter sur `shuttle.local:8069` (directement sur le shuttle dans le réseau local)
6. Configurer identifiants
   1. "Manage databases"
   2. "Set Master Password" pour configurer le mot de passe maitre, et le stocker. Celui est essentiel pour modifier la base de données plus tard.
   3. Connecter en tant qu'admin
   4. Changer le mot de passe d'admin en local sur 8069
7. remettre le fichier à l'origine pour exposer publiquement le site et désactiver l'initialisation

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
