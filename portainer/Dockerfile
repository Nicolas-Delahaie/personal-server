FROM alpine AS writer
ARG PORTAINER_ADMIN_PASSWORD
RUN echo "$PORTAINER_ADMIN_PASSWORD" > /admin-password

FROM portainer/portainer-ce

# WARNING : unsafe but admin-password need hashed password
COPY --from=writer /admin-password /admin-password 

CMD ["--admin-password-file", "/admin-password"]
