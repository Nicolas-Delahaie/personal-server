# Odoo

## Variables d'environnement

Ajouter les variables suivantes dans le fichier `.env` :

1. `ODOO_DB_USER`
2. `ODOO_DB_PASSWORD`
3. `ODOO_DATABASE_NAME`
4. `ODOO_MASTER_PASSWORD`

Pour une première utilisation, suivre impérativement la partie **Application vierge**. Ensuite, lancer Odoo en précisant le profile souhaité:

```bash
docker compose --profile odoo up -d --build
```

## Application vierge

Le premier lancement nécessite une initialisation pour sécuriser la base de données. Cette étape est cruciale car elle protège le site jusqu'à la modification des identifiants par défaut (admin:admin).

1. Ajouter dans le service odoo :

   ```yml
   labels:
     - "traefik.http.routers.odoo.middlewares=auth@docker"
   command: >
     -i base,calendar,account
     --load-language=fr_FR
     --without-demo=all
   ```

2. Lancer les conteneurs (compose up)
3. Attendre la fin de l'initialisation (arrêt des logs du conteneur)
4. Modifier les identifiants :
   1. Cliquer sur la photo de profil en haut à droite
   2. Accéder aux "Préférences"
   3. Ouvrir la section "sécurité du compte"
   4. Modifier le mot de passe
5. Restaurer le fichier d'origine pour exposer publiquement le site et désactiver l'initialisation
6. Relancer les conteneurs (compose up)
