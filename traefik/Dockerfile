FROM traefik:latest

RUN apk add --no-cache apache2-utils

ARG TRAEFIK_USER
ARG TRAEFIK_PASSWORD
ARG PASSWORD_FILE_PATH

COPY generate-hashed-password.sh ./generate-hashed-password.sh

RUN mkdir -p /acme &&\
    touch /acme/acme.json &&\
    chmod 600 /acme/acme.json

RUN chmod +x ./generate-hashed-password.sh && \
    ./generate-hashed-password.sh "$TRAEFIK_USER" "$TRAEFIK_PASSWORD" "$PASSWORD_FILE_PATH"

VOLUME [ "/acme" ] 
