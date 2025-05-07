FROM traefik:latest

RUN apk add --no-cache apache2-utils

ARG TRAEFIK_USER
ARG TRAEFIK_PASSWORD
ARG PASSWORD_FILE_PATH

COPY generate-hashed-password.sh ./generate-hashed-password.sh
COPY ./traefik.yml /etc/traefik/traefik.yml
COPY ./dynamic_conf.yml /etc/traefik/dynamic_conf.yml

RUN chmod +x ./generate-hashed-password.sh && \
    ./generate-hashed-password.sh "$TRAEFIK_USER" "$TRAEFIK_PASSWORD" "$PASSWORD_FILE_PATH"