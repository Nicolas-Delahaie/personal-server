# Connexion SSH au Shutle

> Connexion entre shutle (mini ordi Debian) et mac via ethernet uniquement (pas d'internet)

## Prérequis

1. Branchements doivent être bons (pas d’ethernet débranché)
2. Activer le port réseau
   1. Vérifier laquelle des carte est utilisée via `ip a`
   2. Activer le port ethernet lié via `nmtui` (network-manager doit être installé)
3. Configurer le hostname via nmtui

## Configuration SSH

Le SSH permet de se connecter à distance au Shuttle, permettant de le contrôler et de le gérer sans avoir à se déplacer physiquement. Il est essentiel de sécuriser cette connexion pour éviter les accès non autorisés.

La configuration du SSH est trouvable [ici](docs/ssh-configuration.md)

## Réseau local avec le Shuttle

Bien que ce soit facultatif, il est préférable de configurer un accès direct au Shuttle dans le cas où la boxe internet ne fonctionnerait plus.

La configuration de la connexion locale est trouvable [ici](docs/private-net-configuration.md).

## Configuration réseau externe (DNS et ports)

Pour que le Shuttle soit accessible depuis l'extérieur, il est nécessaire de configurer la Freebox. On peut également configurer le nom de domaine pour qu'il pointe vers l'IP publique de la Freebox, pour ne pas avoir à se souvenir de l'IP publique.

La configuration est présente [ici](docs/dns-ports-configuration.md#configuration-des-ports).
