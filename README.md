# Services et configurations pour le serveur personnel

Explications de la mise en place d'un serveur perso et codes divers. Dans mon cas, j'utilise un "Shuttle" (ordinateur compact) en Debian, mais cette configuration peut s'adapter à tout type de serveur.

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

## Configuration du serveur

Pour configurer votre serveur (dans mon cas un Shuttle), lire la documentation [ici](./docs/server-setup.md).

## Conseils de développement

### Développement via SSH

Pour un développement efficace nécessitant des modifications et relances fréquentes :

1. Utilisez l'extension VSCode `ms-vscode-remote.remote-ssh` pour développer directement sur le serveur.
2. Testez les modifications sur le serveur
3. Une fois fonctionnelles, copiez-les en local et commitez

Cette approche évite le cycle répétitif modifier-commit-push-pull-tester.

**Important** : Pour éviter toute confusion, gardez une séparation claire entre les modifications locales et celles sur le serveur.

### Développement local

Pour le développement local avant la production, il faut configurer un DNS local. La configuration est présente [ici](./docs/dnsmasq.md#configuration-du-dns).
