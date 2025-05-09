### 1. Configuration IP fixe

1. Obtenir une IP fixe :

   - Se connecter sur <https://adsl.free.fr>
   - Aller dans "Ma Freebox"
   - "Demander une adresse IP fixe V4 full-stack"

2. Vérifier l'IP publique :
   - Aller dans "État de la Freebox"
   - Noter l'adresse IPv4 publique

### 2. Redirection des ports

Sur <http://mafreebox.freebox.fr> :

- Rediriger les ports suivants vers l'IP locale du Shuttle :
  - 22 (SSH)
  - 80 (HTTP)
  - 443 (HTTPS)

### 3. Configuration DNS

1. Configuration OVH :

   - Pointer le domaine vers l'IP publique de la Freebox
   - Ajouter l'enregistrement wildcard : `*.<domaine> A <ip_publique>`

2. Optimisation DNS Freebox (pour que la propagation soit plus rapide, à cause du caching DNS de la Freebox) :

   - Aller dans "Paramètres de la Freebox > DHCP > DNS"
   - Ajouter en début de liste :
     1. 8.8.8.8 (Google)
     2. 1.1.1.1 (Cloudflare)

   > Le nom de domaine sera alors directement résolu via Google, sans passer par le système de la boxe qui est inadapté au développement.  
   > Pour vérifier la propagation DNS : utiliser <www.whatsmydns.net>. Il permet de voir la destination en temps réel d'un IP, sans la latence de la mise à jour du cache des DNS intermédiaires.
