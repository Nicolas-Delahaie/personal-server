# Checklist : ajout d'un nouveau service

Ce document liste les étapes à ne pas oublier lors de la création d'un nouveau service.

## Obligations

1. **CrowdSec** : chercher une collection qui couvre les logs du service
2. **Labels Traefik** : ajouter le middleware `errp-redirect@file`
3. **Volumes** : ajouter `:ro` dès que possible
4. **Variables d'environnement** : s'il y en a beaucoup, diviser entre `env_file` et `environment`
5. **Documentation** : documenter les étapes obligatoires et facultatives dans le README

## Conseils

1. Mettre une étoile sur le dépôt GitHub du service pour le suivi de version
2. Privilégier un seul dossier par service. Si des services sont liés, les regrouper dans un dossier parent
3. Dé-versionner correctement les valeurs sensibles — `.env` + `.gitignore`
4. Persister au maximum les configurations pour conserver un dépôt plug and play, préconfiguré dès le pull
