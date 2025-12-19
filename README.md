# Services et configurations pour le serveur personnel

Explications de la mise en place d'un serveur personnel et codes divers. Cette configuration, bien que basée sur un "Shuttle" (ordinateur compact) sous Debian, peut s'adapter à tout type de serveur.

## Installation

1.  Configurer les variables d'environnement

    1. Générer le fichier vierge :

       ```bash
       cp .env.template .env
       ```

    2. Completer le fichier généré avec les variables d'environnement nécessaires.

2.  Exécuter la commande suivante :

    ```bash
    docker compose up -d --build
    ```

    > Cette commande exécute les conteneurs minimums nécessaires au fonctionnement du projet. Pour activer des services supplémentaires, ajouter le profile correspondant dans la commande. Par exemple, pour activer le profile `portainer`, ajouter `--profile monit`.

3.  Frigate : se connecter avec le mot de passe admin généré automatiquement (visible dans les logs via `docker compose logs frigate`) et le modifier.

4.  CrowdSec :

    1.  Blocage IP au niveau de l'hôte (Firewall Bouncer Crowdsec) :

        1. Installation :

           ```bash
           sudo apt install --no-install-recommends crowdsec-firewall-bouncer
           sudo systemctl enable --now crowdsec-firewall-bouncer # Par sécurité
           ```

        2. Initialiser la clé API du service Crowdsec :

           ```bash
           docker compose exec cs cscli bouncers add firewall
           ```

           Cette commande génère une clé API. Il faut ensuite la copier dans le fichier de config `.local` du firewall bouncer (précisé lors de l'installation).

        3. (Optionnel) Empêcher le service de planter lorsque l'API Crowdsec n'est pas encore disponible :

           ```bash
           sudo systemctl edit crowdsec-firewall-bouncer.service
           ```

           Ajouter les lignes suivantes :

           ```ini
           [Service]
           Restart=always
           RestartSec=60
           ```

           > Au démarrage, le service tentera de se relancer toutes les minutes jusqu'à ce que l'API soit disponible (conteneur Docker Crowdsec démarré).

    2.  (Optionnel) Configurer l'interface distance de monitoring (Console):

        > La Console de Crowdsec permet de visualiser les alertes et la santé de l'instance Crowdsec via une interface web externe.

        1.  Authentification sur <https://docs.crowdsec.net/u/getting_started/post_installation/console>
        2.  Suivre la procédure (appairage de l'instance puis redémarrage)

5.  (Optionnel) Pour activer le démarrage automatique des services au lancement du serveur, créer ce service `systemctl` de lancement automatique :

```bash
sudo cp host_configs/personal-server.service /etc/systemd/system/
sudo systemctl enable personal-server
```

> Grâce à ce service, les conteneurs se lanceront automatiquement au démarrage du serveur. Notamment en cas de coupure de courant. `restart=unless-stopped` a été désactivé pour faciliter le diagnostic des plantages et éviter les redémarrages en boucle.

## Configuration du serveur

Pour la configuration du serveur, suivre la documentation [ici](./docs/server-setup.md).
