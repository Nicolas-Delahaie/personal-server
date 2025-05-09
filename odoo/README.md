# Odoo

## Variables d'environnement

Dans le fichier `.env`, il faut ajouter les variables suivantes :

1. `ODOO_DB_USER`
1. `ODOO_DB_PASSWORD`
1. `ODOO_DATABASE_NAME`
1. `ODOO_MASTER_PASSWORD`

Si première utilisation, absolument suivre la partie **Application vierge**. Sinon, lancer Odoo normalement. Pour ce faire, lancer Odoo en précisant le profile au lancement :

```bash
docker compose --profile odoo up -d --build
```

## Application vierge

Le premier lancement nécessite une manipulation pour initialiser et sécuriser la base de données. Cette étape est cruciale car elle rend public le site uniquement lorsque les identifiants ne sont plus admin:admin.

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
3. Attendre que l'initialisation ait terminé (logs du conteneur se stoppent)
4. Modifier identifiants :
   1. Photo de profil en haut à droite
   2. "Préférences"
   3. Section "sécurité du compte"
   4. "Modifier le mot de passe"
5. Remettre le fichier à l'origine pour exposer publiquement le site et désactiver l'initialisation
6. Relancer les conteneurs (compose up)

## Restauration de sauvegarde
