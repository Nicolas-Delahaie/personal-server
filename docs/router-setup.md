# Configuration box internet et DNS

Cette configuration s'applique à la Freebox mais peut être adaptée à d'autres box internet.

## Configuration IP fixe

Une adresse IP fixe est nécessaire pour router le serveur sur internet. Cela assure la stabilité de l'adresse IP publique, essentielle pour la redirection des ports et la configuration DNS.

1. Obtention d'une IP fixe :

   - Se connecter sur <https://adsl.free.fr>
   - Accéder à "Ma Freebox"
   - Sélectionner "Demander une adresse IP fixe V4 full-stack"

2. Récupération de l'IP publique :
   - Consulter "État de la Freebox"
   - Noter l'adresse IPv4 publique

## Redirection des ports

Sur l'intranet de la box (<http://mafreebox.freebox.fr> chez Free), configurer la redirection des ports suivants vers l'IP locale du serveur :

- 22 (SSH)
- 80 (HTTP)
- 443 (HTTPS)

Cette configuration permet l'accès au serveur depuis l'extérieur via SSH ou navigateur web.

## Configuration du DNS

1. Configuration OVH :
   - Configurer le domaine vers l'IP publique de la box
   - Ajouter l'enregistrement wildcard pour rediriger les sous domaines : `*.<domaine> A <ip_publique>`

## Nom de domaine local

Pour résoudre le nom de domaine directement vers l'IP locale du serveur sans passer par internet, configurer le nom de domaine sur la box.

Sur la Freebox : Paramètres de la Freebox > "Nom de domaine" > Ajouter un domaine.

## Débogage

### Bypass DNS cache

Pour vérifier la propagation DNS : utiliser <www.whatsmydns.net>. Cet outil affiche la destination en temps réel d'une IP, sans la latence du cache DNS.

Pour accélérer la propagation (ignorer le cache DNS de la box) :

- Dans "Paramètres de la box > DHCP > DNS"
- Ajouter en début de liste :
  1. 8.8.8.8 (Google)
  2. 1.1.1.1 (Cloudflare)

> Le nom de domaine sera ainsi résolu directement via Google, évitant le système de cache de la box peu adapté au développement.
