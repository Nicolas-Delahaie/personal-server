# Configuration du serveur

Configuration du serveur (dans cet exemple, un Shuttle sous Debian) pour permettre son accès depuis l'extérieur via SSH ou via Ethernet en local.

## Prérequis

1. Vérifier les branchements (Ethernet correctement connecté)
2. Installer `network-manager` si nécessaire :

   ```bash
   sudo apt install network-manager
   ```

3. Configurer le réseau :

   ```bash
   sudo nmtui
   ```

   1. Définir le nom d'hôte du système
   2. Configurer la connexion ethernet :
      - Sélectionner "Modifier une connexion"
      - Si aucune connexion n'existe sous "Ethernet", en ajouter une
      - Conserver les valeurs par défaut et valider

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
