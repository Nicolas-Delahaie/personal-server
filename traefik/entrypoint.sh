#!/bin/sh
set -eu

template="/etc/traefik/traefik_template.yml"
output="/etc/traefik/traefik.yml"

vars=$(grep -oE '\$\{[A-Za-z_][A-Za-z0-9_]*\}' "$template" | sed 's/[${}]//g' | sort -u)
if [ -z "$vars" ]; then
    cp "$template" "$output"
else
    set --
    for v in $vars; do
        val=$(printenv "$v") || { echo "Missing env: $v" >&2; exit 1; }
        esc=$(printf '%s' "$val" | sed 's/[\\&|]/\\&/g')
        set -- "$@" -e "s|\\\${$v}|$esc|g"
    done
    sed "$@" "$template" > "$output"
fi

exec traefik