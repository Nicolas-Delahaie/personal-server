#!/bin/sh
set -e

TRAEFIK_USER="$1"
TRAEFIK_PASSWORD="$2"
PASSWORD_FILE_PATH="$3"

# Validate parameters
if [ -z "$TRAEFIK_USER" ] || [ -z "$TRAEFIK_PASSWORD" ] || [ -z "$PASSWORD_FILE_PATH" ]; then
    echo "[!] Utilisation : $0 <utilisateur> <mot_de_passe> <chemin_fichier>"
    exit 1
fi

# Validate that PASSWORD_FILE_PATH looks like an absolute path
if ! echo "$PASSWORD_FILE_PATH" | grep -q '^/'; then
    echo "[!] Le chemin fourni ne ressemble pas à un chemin absolu : $PASSWORD_FILE_PATH"
    exit 1
fi

# Ensure directory exists
mkdir -p "$(dirname "$PASSWORD_FILE_PATH")"

# Check if the file exists and is not a regular file
if [ -e "$PASSWORD_FILE_PATH" ] && [ ! -f "$PASSWORD_FILE_PATH" ]; then
    echo "[!] Le chemin désigne une ressource qui n'est pas un fichier : $PASSWORD_FILE_PATH"
    exit 1
fi

# Check if the file exists and is non-empty
if [ -s "$PASSWORD_FILE_PATH" ]; then
    echo "[!] Le fichier existe déjà et n'est pas vide : $PASSWORD_FILE_PATH"
    exit 1
fi

# Génère le fichier d'auth
echo "[+] Génération du fichier d'auth Traefik dans $PASSWORD_FILE_PATH..."
htpasswd -nbB "$TRAEFIK_USER" "$TRAEFIK_PASSWORD" > "$PASSWORD_FILE_PATH"
