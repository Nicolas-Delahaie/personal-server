# Home Srv

Serveur personnel domestique basé sur Docker Compose. Hébergé sur un Shuttle sous Debian.
Regroupe domotique, vidéosurveillance, gestion de mots de passe, streaming média et sécurité réseau.

## Stack technique

- **Orchestration** : Docker Compose (fichier unique `compose.yml`)
- **Reverse proxy** : Traefik (SSL/TLS via Let's Encrypt, DNS challenge OVH)
- **Authentification** : Authelia (SSO, 2FA, ForwardAuth via Traefik)
- **Domotique** : Home Assistant + Zigbee2MQTT + Mosquitto (MQTT)
- **Vidéosurveillance** : Frigate (détection IA) + go2rtc (streaming RTSP)
- **Mots de passe** : Vaultwarden
- **Sécurité** : CrowdSec (détection de menaces, analyse de logs Traefik)
- **Monitoring** : Glances
- **Administration** : Portainer
- **Média** (profil `stream`, optionnel) : qBittorrent + Radarr + Prowlarr

## Structure du projet

```text
compose.yml                    # Orchestration principale
.env.template                  # Template des variables d'environnement
generate_env_file.sh           # Génération automatique du .env depuis compose.yml
traefik/                       # Config statique (template) + dynamique + logs
authelia/config/               # Config Authelia + base utilisateurs
ha/config/                     # Home Assistant (configuration.yaml, automations, custom_components)
frigate/config/                # Frigate (config.yaml, model_cache)
frigate/media/                 # Enregistrements, clips, exports
z2m/data/                      # Zigbee2MQTT (config + devices)
mosquitto/                     # Config MQTT broker
cs/config/                     # CrowdSec (parsers, scenarios, collections)
vw/                            # Vaultwarden
glances/                       # Config monitoring système
grdf/                          # Relevé compteur gaz (Gazpar)
host_configs/                  # Fichiers système hôte (systemd service)
docs/                          # Documentation (setup, accès, réseau, drawio)
streaming/                     # Downloads et bibliothèque média
```

## Conventions de nommage

- **Services dans compose** : noms courts (`traefik`, `authelia`, `ha`, `z2m`, `mosquitto`, `vw`, `cs`, `qbt`, `radarr`, `prowlarr`)
- **Caméras** : nommées par modèle (`tapo-c200`), pas par numéro. Variables env : `CAM1_USER`, `CAM1_PASSWORD`, `CAM1_IP`
- **Streams vidéo** : `tapo_c200` (haute qualité), `tapo_c200_sub` (basse qualité) dans go2rtc
- **Configs** : `./service/config/` pour la configuration, `./service/data/` ou volumes pour les données
- **Logs** : `./service/log/` ou `./traefik/logs/`

## Réseau

- Réseau bridge Docker : subnet `172.50.0.0/16` (configurable via `SUBNET_IP`)
- Home Assistant : `network_mode: host` (pour mDNS) ; Mosquitto : port mapping uniquement (`127.0.0.1:1883`)
- Ports sensibles exposés en localhost uniquement : Portainer (`127.0.0.1:9000`), CrowdSec API (`127.0.0.1:8080`), MQTT (`127.0.0.1:1883`)
- Traefik expose 80 (redirect) et 443 (HTTPS)

## Commandes courantes

```bash
# Démarrage standard
docker compose up -d --build

# Avec profil streaming (média)
docker compose --profile stream up -d

# Logs d'un service
docker compose logs -f <service>

# Redémarrage d'un service
docker compose restart <service>
```

## Règles pour les contributions

- **Langue** : tout le code (variables, fonctions, commentaires dans le code, noms de fichiers de config) doit être en **anglais**. Seuls les README, commits, documentation (`docs/`) et messages utilisateur sont en **français**
- **Configuration** : toute valeur sensible doit être dans `.env` (jamais en dur dans les fichiers YAML)
- **Variables d'environnement** : utiliser `${VAR}` dans compose.yml, documenter dans `.env.template`
- **Fichiers ignorés par git** : `.env`, configs runtime HA/Frigate/Z2M, logs, médias (voir `.gitignore`)
- Ne pas modifier les fichiers générés automatiquement par les services (ex: bases SQLite, caches)
- Préférer les modifications via les fichiers de config YAML plutôt que via les UI des services
- Les templates Traefik utilisent `envsubst` à l'exécution (`traefik_static_template.yml` → config finale)

## Documentation de référence

Consulter ces fichiers selon le contexte de la tâche :

| Quand                               | Fichier                         |
| ----------------------------------- | ------------------------------- |
| Ajout d'un nouveau service          | `docs/new-service-checklist.md` |
| Configuration serveur / réseau hôte | `docs/server-setup.md`          |
| Accès SSH                           | `docs/remote-access.md`         |
| Réseau local / APIPA                | `docs/offline-network.md`       |
| Configuration routeur / DNS         | `docs/router-setup.md`          |
| DNS local (dnsmasq)                 | `docs/dnsmasq.md`               |

Les sous-dossiers des services contiennent aussi des `CLAUDE.md` avec les règles spécifiques :

- `traefik/CLAUDE.md` — middlewares, templates, errp-redirect
- `frigate/CLAUDE.md` — go2rtc, WebRTC, caméras, streaming
- `authelia/CLAUDE.md` — ForwardAuth, OIDC, base utilisateurs
- `ha/CLAUDE.md` — network_mode host, custom components, intégrations
- `cs/CLAUDE.md` — CrowdSec, parsers, analyse de logs
