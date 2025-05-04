FROM odoo:18

ARG ODOO_MASTER_PASSWORD
ARG ODOO_DATABASE_NAME

USER root

RUN echo "admin_passwd = ${ODOO_MASTER_PASSWORD}" >> /etc/odoo/odoo.conf && \
    echo "db_name = ${ODOO_DATABASE_NAME}" >> /etc/odoo/odoo.conf && \
    echo "debug_mode = False" >> /etc/odoo/odoo.conf && \
    echo "list_db = False" >> /etc/odoo/odoo.conf

USER odoo