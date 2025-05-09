# Services et configurations pour le serveur personnel

Explications de la mise en place d'un serveur perso et codes divers. Dans mon cas, j'utilise un "Shuttle" (ordinateur compact) en Debian.

## Installation

Pour lancer le projet, créer un fichier `.env` avec les variables obligatoires suivantes :

1. `HOSTNAME`
2. `TRAEFIK_USER`
3. `TRAEFIK_PASSWORD`

Ensuite, exécuter la commande suivante :

```bash
docker compose up -d --build
```

> Cela exécute les conteneurs minimums nécessaires au fonctionnement du projet. Si vous avez besoin de plus de services, il faut les activer dans le fichier `docker-compose.yml` en ajoutant le profile correspondant. Par exemple, pour activer le profile `odoo`, il faut ajouter `--profile odoo` à la commande ci-dessus.

## Odoo

Pour configurer Odoo, lire sa documentation [ici](odoo/README.md).

## Configuration Shuttle

Pour configurer le Shuttle, lire la documentation [ici](docs/shuttle-configuration.md).

## Conseils de développement

### Développement via SSH

Pour les modifications nécessitant le relancement fréquent des conteneurs et des tests, je recommande de développer directement dans le shuttle, notamment via l'extension VSCode `ms-vscode-remote.remote-ssh`. Ensuite lorsque la modification fonctionne, copier coller et comiter en local. De cette manière, pas besoins de modifier-commit-push-pull-tester à chaque modification du code.

Je recommande aussi de faire attention à garder les modifications effectives sois en local, sois sur la Shuttle pour ne pas s'emmêler les pinceaux.

### Configuration DNS local pour Traefik

Pour le développement local avant la production, il est nécessaire de configurer le DNS local. La configuration est présente [ici](docs/dnsmasq-configuration.md#configuration-du-dns).
