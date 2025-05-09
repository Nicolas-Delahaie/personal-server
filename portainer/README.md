# Portainer

Le mot de passe de Portainer au premier lancement sera celui défini dans la variable `PORTAINER_ADMIN_PASSWORD`.

En cas de modification de mot de passe, 2 méthodes possibles :

1. Au niveau du code :
   1. Arrêter le conteneur en supprimant ses données : `docker compose down portainer -v` (-v pour supprimer le volume)
   2. Modifier la variable : `PORTAINER_ADMIN_PASSWORD`
   3. Relancer : `docker compose up portainer -d --build`
2. Via l'interface graphique :
   1. Accéder à `Admin` en haut à droite
   2. Sélectionner `My account`
   3. Utiliser `Change user password`
   4. Note : cette méthode ne conserve pas la trace du nouveau mot de passe dans le code
