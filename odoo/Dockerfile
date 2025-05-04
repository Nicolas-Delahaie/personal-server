FROM odoo:18

ARG DEFAULT_ADMIN_PASSWD
ARG ODOO_DATABASE_NAME

USER root

RUN sed -i "s/^; admin_passwd = admin/admin_passwd = ${DEFAULT_ADMIN_PASSWD}/" /etc/odoo/odoo.conf && \
    sed -i "s/^; db_name = False/db_name = ${ODOO_DATABASE_NAME}/" /etc/odoo/odoo.conf && \
    sed -i "s/^; list_db = False/list_db = False/" /etc/odoo/odoo.conf && \
    sed -i "s/^; debug_mode = False/debug_mode = False/" /etc/odoo/odoo.conf

USER odoo