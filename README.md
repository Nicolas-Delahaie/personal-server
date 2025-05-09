# Services et configurations pour le serveur personnel

Explications de la mise en place d'un serveur perso et codes divers. Dans mon cas, j'utilise un "Shuttle" (ordinateur compact) en Debian.

## Installation

Pour lancer le projet, créer un fichier `.env` avec les variables obligatoires suivantes :

1. `HOSTNAME`
2. `PORTAINER_ADMIN_PASSWORD`
3. `TRAEFIK_USER`
4. `TRAEFIK_PASSWORD`

Ensuite, exécuter la commande suivante :

```bash
docker compose up -d --build
```

## Odoo

Pour configurer Odoo, lire sa documentation [ici](odoo/README.md).
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


## Conseils de développement

### Développement via SSH

Pour les modifications nécessitant le relancement fréquent des conteneurs et des tests, je recommande de développer directement dans le shuttle, notamment via l'extension VSCode `ms-vscode-remote.remote-ssh`. Ensuite lorsque la modification fonctionne, copier coller et comiter en local. De cette manière, pas besoins de modifier-commit-push-pull-tester à chaque modification du code.

Je recommande aussi de faire attention à garder les modifications effectives sois en local, sois sur la Shuttle pour ne pas s'emmêler les pinceaux.

### Configuration DNS local pour Traefik

Pour le développement local avant la production, il est nécessaire de configurer le DNS local. La configuration est présente [ici](docs/dnsmasq-configuration.md#configuration-du-dns).
