# Services et configurations pour le serveur personnel

Explications de la mise en place d'un serveur personnel et codes divers. Cette configuration, bien que basée sur un "Shuttle" (ordinateur compact) sous Debian, peut s'adapter à tout type de serveur.

## Installation

1. Configurer les variables d'environnement

   1. Générer le fichier vierge :

      ```bash
      cp .env.template .env
      ```

   2. Completer le fichier généré avec les variables d'environnement nécessaires.

2. Exécuter la commande suivante :

   ```bash
   docker compose up -d --build
   ```

   > Cette commande exécute les conteneurs minimums nécessaires au fonctionnement du projet. Pour activer des services supplémentaires, ajouter le profile correspondant dans la commande. Par exemple, pour activer le profile `portainer`, ajouter `--profile monit`.

3. Configurer le service Frigate

   1. Reintialiser le password admin généré automatiquement (visible dans les logs via `docker compose logs frigate`).
   2. Modifier la configuration `frigate/config/config.yaml` et désactiver le TLS pour Traefik :

      ```yaml
      tls: # For reverse proxy
        enabled: false
      ```

   3. Configurer entièrement le fichier de config Frigate en suivant la documentation officielle [ici]().

4. (Optionnel) Configurer le dashboard de Crowdsec
   1. Connexion à l'interface distante de monitoring : <https://docs.crowdsec.net/u/getting_started/post_installation/console>
   2. Suivre la procédure (appairage de l'instance puis redémarrage)

## Configuration du serveur

Pour la configuration du serveur, suivre la documentation [ici](./docs/server-setup.md).
