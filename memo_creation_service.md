# Mémo création service

Ce document a pour but de lister les étapes à ne pas oublier lors de la création d'un nouveau service.

**Obligations :**

1. Crowdsec
   1. chercher une collection qui le couvre
   2. Monter les logs
2. Adapter les labels (utiliser middleware auth si non sécurisé)
3. Ajouter le label `errp-redirect@file`
4. Ajouter `:ro` dès que possible aux volumes
5. Variables d'environnement : s'il y en a beaucoup, diviser entre `env_file` et `environment`
6. Documenter les choses à faire obligatoires / facultatives.

**Conseils :**

1. Mettre une étoile sur le service Github pour le suivi de version
2. En général, on privilégie un seul dossier par service. S'ils sont liés, on peut les regrouper dans un dossier parent. 8. Dé-versionner correctement les variables (surtout sensibles).
3. Persister au maximum les configurations, lorsque possible, pour conserver un dépôt plug and play, préconfiguré dès le pull.
