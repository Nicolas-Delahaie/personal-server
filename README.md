# Services et configurations pour le serveur personnel

Explications de la mise en place d'un serveur personnel et codes divers. Cette configuration, bien que basée sur un "Shuttle" (ordinateur compact) sous Debian, peut s'adapter à tout type de serveur.

## Installation

1. Créer un fichier `.env` avec les variables obligatoires nécessaires au docker compose (utilisées via `${}`)
2. Exécuter la commande suivante :

   ```bash
   docker compose up -d --build
   ```

> Cette commande exécute les conteneurs minimums nécessaires au fonctionnement du projet. Pour activer des services supplémentaires, ajouter le profile correspondant dans la commande. Par exemple, pour activer le profile `odoo`, ajouter `--profile odoo`.

## Odoo

Consulter la documentation Odoo [ici](odoo/README.md).

## Configuration du serveur

Pour la configuration du serveur, suivre la documentation [ici](./docs/server-setup.md).

## Méthodes de développement

### Développement via SSH

Pour un développement efficace avec modifications et relances fréquentes :

1. Installer l'extension VSCode `ms-vscode-remote.remote-ssh` pour développer directement sur le serveur
2. Tester les modifications sur le serveur
3. Après validation, copier en local et commiter

Cette approche évite le cycle répétitif modifier-commit-push-pull-tester.

**Important** : Maintenir une séparation claire entre les modifications locales et celles sur le serveur.

### Développement local

Pour le développement local avant la production, configurer un DNS local selon la documentation [ici](./docs/dnsmasq.md#configuration-du-dns).
