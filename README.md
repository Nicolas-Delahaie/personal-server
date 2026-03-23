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

   > Cette commande exécute les conteneurs minimums nécessaires au fonctionnement du projet. Pour activer des services supplémentaires, ajouter le profile correspondant dans la commande. Par exemple, pour activer le profile `stream`, ajouter `--profile stream`.

3. CrowdSec :
   1. Blocage IP au niveau de l'hôte (Firewall Bouncer Crowdsec) :
      1. Installation :

         ```bash
         sudo apt install --no-install-recommends crowdsec-firewall-bouncer ipset
         sudo systemctl enable --now crowdsec-firewall-bouncer # Par sécurité
         ```

      2. Initialiser la clé API du service Crowdsec :

         ```bash
         docker compose exec cs cscli bouncers add firewall
         ```

         Cette commande génère une clé API. Il faut ensuite créer (ou compléter) le fichier de config `.local` du firewall bouncer `/etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml.local` avec le contenu suivant :

         ```yaml
         mode: iptables
         api_key: <clé générée ci-dessus>
         iptables_chains:
           - INPUT
           - DOCKER-USER
         prometheus:
           enabled: false
         ```

         > Le mode `iptables` est requis pour les environnements Docker : c'est la [recommandation officielle CrowdSec](https://docs.crowdsec.net/u/bouncers/firewall). Il permet d'ajouter la chaîne `DOCKER-USER`, sans laquelle le trafic entrant vers les conteneurs (port forwarding) n'est pas bloqué malgré les décisions de ban. Le mode `nftables` (défaut) ne supporte pas `DOCKER-USER`.

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

   2. (Optionnel) Configurer l'interface distance de monitoring (Console):

      > La Console de Crowdsec permet de visualiser les alertes et la santé de l'instance Crowdsec via une interface web externe.
      1. Authentification sur <https://docs.crowdsec.net/u/getting_started/post_installation/console>
      2. Suivre la procédure (appairage de l'instance puis redémarrage)

4. Authelia :
   1. Créer le fichier contenant les utilisateurs Authelia (dont l'administrateur) :

      ```bash
      cat > ./authelia/config/users_database.yml << 'EOF'
      users:
         admin:
            password: ""
            displayname: "Admin"
      EOF
      ```

   2. Générer le hash du mot de passe administrateur souhaité et le copier dans `user.admin.password` :

      ```bash
      docker run --rm -it authelia/authelia:latest authelia crypto hash generate argon2
      ```

5. Ollama (Open WebUI) :

   Au premier lancement, aucun modèle n'est installé. Il faut en télécharger au moins un pour pouvoir discuter :

   ```bash
   docker compose exec ollama ollama pull mistral
   ```

   Les modèles disponibles sont listés sur [ollama.com/library](https://ollama.com/library). Quelques exemples :

   | Modèle        | Taille  | Description                              |
   | ------------- | ------- | ---------------------------------------- |
   | `mistral`     | ~4 Go   | Bon équilibre performance / taille       |
   | `llama3.2`    | ~2 Go   | Plus léger, adapté aux machines modestes |
   | `llama3.2:1b` | ~1.3 Go | Très léger                               |

   > Les modèles sont persistés dans le volume Docker `ollama_datas`. Ils survivent aux redémarrages et mises à jour du conteneur.

   **Utiliser un serveur Ollama externe (facultatif)** :

   Le serveur embarqué (Shuttle) est limité en puissance. Si un appareil plus performant est disponible sur le réseau local (ex : un laptop puissant avec Ollama installé), Open WebUI peut s'y connecter pour exécuter des modèles plus gourmands.

   Prérequis sur la machine distante :
   1. Installer Ollama ([ollama.com](https://ollama.com))
   2. Activer l'accès externe sur Ollama. Le plus simple est de le faire depuis l'interface d'Ollama : **Settings** > **Networking** > activer **Allow external connections**. Alternativement, on peut définir la variable d'environnement `OLLAMA_HOST=0.0.0.0` avant de lancer Ollama.
   3. Créer un **bail statique (DHCP)** sur le routeur pour cette machine, afin que son IP locale ne change pas (le mDNS ne fonctionne pas avec Open WebUI, il faut une IP fixe)

   Configuration dans Open WebUI :
   1. Se connecter à Open WebUI
   2. Aller dans **Administration** > **Paramètres** > **Connexions**
   3. Dans la section **Ollama**, ajouter une nouvelle connexion avec l'URL `http://<IP_FIXE_DU_LAPTOP>:11434`
   4. Vérifier la connexion : les modèles installés sur la machine distante doivent apparaître dans la liste des modèles disponibles

   > Lorsque le laptop est connecté et accessible sur le réseau local, Open WebUI peut y accéder et faire tourner des modèles bien plus puissants que ce que permet le serveur. Quand la machine est éteinte ou absente du réseau, seuls les modèles locaux du serveur restent disponibles.

6. (Optionnel) Pour activer le démarrage automatique des services au lancement du serveur, créer ce service `systemctl` de lancement automatique :

   ```bash
   sudo cp host_configs/personal-server.service /etc/systemd/system/
   sudo systemctl enable personal-server
   ```

   > Grâce à ce service, les conteneurs se lanceront automatiquement au démarrage du serveur. Notamment en cas de coupure de courant. `restart=unless-stopped` a été désactivé pour faciliter le diagnostic des plantages et éviter les redémarrages en boucle.

7. (Optionnel) Configuration des services de streaming (profile `movies`)

   > Ces services doivent être configurés via l'interface (non configurable par variable d'environnement docker)
   1. QBitorrent :
      1. Se connecter grâce au mot de passe admin temporaire récupérable dans les logs :

         ```bash
         docker compose logs qbt
         ```

      2. Modifier l'utilisateur : Tools > Options > WebUI > Authentication

   2. Radarr :
      1. Accéder à la popup de configuration initiale
      2. Sélectionner `Authentication Required` à `Enabled`
      3. Définir l'utilisateur principal
      4. Configurer QBittorent comme client de téléchargement dans Settings > Download Clients. Sélectionner qBitorrent et saisir l'hôte `qbt`, l'utilisateur et le mot de passe définis précédemment.

   3. Prowlarr : la configuration est libre

8. (Optionnel) Streaming cloud sur détection (YouTube Live) :
   1. Dans YouTube Studio, créer un nouveau flux en direct (onglet "En direct"), copier la clé de flux générée et configurer le stream en **Privé**
   2. Copier la clé dans `.env` : `YOUTUBE_STREAM_KEY=xxxx-xxxx-xxxx`
   3. `docker compose restart ha`

   > YouTube peut afficher un warning "débit inférieur au recommandé" — c'est normal en scène statique (H264 compresse très efficacement). Le débit remonte automatiquement dès qu'il y a du mouvement.

## Pare-feu et réseau

Le serveur **ne doit pas avoir de pare-feu actif** (ufw, iptables) au niveau de l'hôte — cela risque de bloquer des services internes. Le filtrage Internet se fait **au niveau du routeur** : seuls les ports 80 et 443 y sont forwardés vers le serveur.

Les ports non forwardés par le routeur restent accessibles sur le LAN, mais ne sont pas non sécurisés pour autant : tous les services passent par Traefik + Authelia ou disposent de leur propre authentification. Les services sans auth sont liés à `127.0.0.1` uniquement.

**CrowdSec** complète le dispositif en bloquant les IPs malveillantes via le firewall bouncer.

## Configuration du serveur

Pour la configuration du serveur, suivre la documentation [ici](./docs/server-setup.md).
