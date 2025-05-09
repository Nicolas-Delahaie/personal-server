# Configuration du Shuttle

> Configuration Shuttle (mini ordi Debian) pour permettre son accès depuis l'extérieur via SSH ou via Ethernet en local.

## Prérequis

1. Branchements doivent être bons (pas d’ethernet débranché)
2. Installer `network-manager` si pas déjà fait : `sudo apt install network-manager`
3. Exécuter `sudo nmtui`
   1. Configurer le hostname depuis "Définir le nom d'hôte du système"
   2. Configurer la connexion ethernet
      1. "Modifier une connexion"
      2. Si rien dans "Ethernet", ajouter une connexion
         1. Laisser les valeurs par défaut puis valider

## Configuration SSH

Le SSH permet de se connecter à distance au Shuttle, permettant de le contrôler et de le gérer sans avoir à se déplacer physiquement. Il est essentiel de sécuriser cette connexion pour éviter les accès non autorisés.

La configuration du SSH est trouvable [ici](./remote-access.md)

## Réseau local avec le Shuttle

Bien que ce soit facultatif, il est préférable de configurer un accès direct au Shuttle dans le cas où la boxe internet ne fonctionnerait plus.

La configuration de la connexion locale est trouvable [ici](./offline-network.md).

## Configuration réseau externe (DNS et ports)

Pour que le Shuttle soit accessible depuis l'extérieur, il est nécessaire de configurer sa boxe. On peut aussi configurer le nom de domaine pour qu'il pointe vers l'IP publique de la Freebox, pour ne pas avoir à se souvenir de l'IP publique.

La configuration est présente [ici](./router-setup.md#configuration-des-ports).
