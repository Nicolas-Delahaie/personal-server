# Mémo création service

Ce document a pour but de lister les étapes à ne pas oublier lors de la création d'un nouveau service.

1. Crowdsec
   1. chercher une collection qui le couvre
   2. Monter les logs
2. Adapter les labels (utiliser middleware auth si non sécurisé)
3. Ajouter le label `errp-redirect@file`
4. Ajouter `:ro` dès que possible aux volumes
