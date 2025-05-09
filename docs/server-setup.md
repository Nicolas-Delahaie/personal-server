# Configuration du serveur

> Configuration du serveur (dans cet exemple, un Shuttle sous Debian) pour permettre son accès depuis l'extérieur via SSH ou via Ethernet en local.

## Prérequis

1. Branchements doivent être bons (pas d'Ethernet débranché)
2. Installer `network-manager` si pas déjà fait : `sudo apt install network-manager`
3. Exécuter `sudo nmtui`
   1. Configurer le hostname depuis "Définir le nom d'hôte du système"
   2. Configurer la connexion ethernet
      1. "Modifier une connexion"
      2. Si rien dans "Ethernet", ajouter une connexion
         1. Laisser les valeurs par défaut puis valider

## Configuration de l'accès

Le serveur nécessite plusieurs configurations pour être pleinement opérationnel :

### Accès SSH

Pour la gestion à distance sécurisée du serveur  
➜ [Configuration SSH détaillée](./remote-access.md)

### Réseau local

Pour un accès direct au serveur, indépendant de la connexion internet  
➜ [Configuration du réseau local](./offline-network.md)

### Accès externe

Pour l'accès depuis internet (configuration DNS et redirection de ports)  
➜ [Configuration du routeur et DNS](./router-setup.md)
