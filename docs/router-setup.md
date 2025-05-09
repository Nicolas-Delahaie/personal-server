# Configuration box internet et DNS

Cette configuration s'applique à la Freebox, mais peut être adaptée à d'autres box internet.

## Configuration IP fixe

Pour router le serveur sur internet, il est nécessaire d'avoir une adresse IP fixe. Cela permet de s'assurer que l'adresse IP publique ne change pas, ce qui est essentiel pour la redirection des ports et la configuration DNS.

1. Obtenir une IP fixe :

   - Se connecter sur <https://adsl.free.fr>
   - Aller dans "Ma Freebox"
   - "Demander une adresse IP fixe V4 full-stack"

2. Vérifier l'IP publique :
   - Aller dans "État de la Freebox"
   - Noter l'adresse IPv4 publique

## Redirection des ports

Sur l'intranet de la boxe (<http://mafreebox.freebox.fr> chez Free), rediriger les ports suivants vers l'IP locale du serveur :

- 22 (SSH)
- 80 (HTTP)
- 443 (HTTPS)

Cela permet d'accéder au serveur depuis l'extérieur via SSH ou un navigateur web.

## Configuration du DNS

1. Configuration OVH :

   - Pointer le domaine vers l'IP publique de la box internet
   - Ajouter l'enregistrement wildcard : `*.<domaine> A <ip_publique>`

## Nom de domaine local

On peut configurer son nom de domaine sur la box, pour qu'elle résolve directement le nom de domaine vers l'IP locale du serveur, sans passer par internet.

Sur le Freebox, aller dans "Paramètres de la Freebox > "Nom de domaine" > Ajouter un domaine".

## Débogage

### Bypass DNS cache

Pour vérifier la propagation DNS : utiliser <www.whatsmydns.net>. Il permet de voir la destination en temps réel d'un IP, sans la latence de la mise à jour du cache des DNS intermédiaires.

Sinon, pour que la propagation soit plus rapide (pour ignorer le caching DNS de la box) :

- Sur MacOS, aller dans "Paramètres de la box > DHCP > DNS"
- Ajouter en début de liste :
  1. 8.8.8.8 (Google)
  2. 1.1.1.1 (Cloudflare)

> Le nom de domaine sera alors directement résolu via Google, sans passer par le système de la box qui est inadapté au développement.
