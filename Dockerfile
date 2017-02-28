FROM clouder/base:3.4
MAINTAINER Yannick Buron yannick.buron@gmail.com

#RUN touch /tmp/odoo-exec
# generate locales
#RUN locale-gen en_US.UTF-8 && update-locale
#RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, 9.4.
# install dependencies as distrib packages when system bindings are required
# some of them extend the basic odoo requirements for a better "apps" compatibility
# most dependencies are distributed as wheel packages at the next step
#RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && apt-get update && apt-get -yq install adduser ghostscript postgresql-client-9.5 python python-pip libjpeg-dev libfreetype6-dev zlib1g-dev libpng12-dev python-imaging python-pychart python-libxslt1 xfonts-base xfonts-75dpi libxrender1 libxext6 fontconfig python-zsi python-lasso libzmq5 libxslt1-dev libxml2-dev libxml2 libxslt1.1 python-dev libpq-dev libffi-dev libldap2-dev libssl-dev libsasl2-dev openssh-client node-less

RUN apk add --update --no-cache postgresql-client nodejs py2-pip \
        && apk add --update --no-cache --virtual .build-deps gcc libffi-dev libjpeg-turbo-dev libxslt-dev linux-headers musl-dev openldap-dev postgresql-dev python-dev \
        && pip --no-cache-dir install --upgrade setuptools pip \
        && pip --no-cache-dir install --upgrade -r https://raw.githubusercontent.com/odoo/odoo/8.0/requirements.txt \
        && pip --no-cache-dir install --upgrade -r https://raw.githubusercontent.com/odoo/odoo/9.0/requirements.txt \
        && pip --no-cache-dir install --upgrade -r https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt \
        && pip --no-cache-dir install --upgrade paramiko erppeek \
        && easy_install -UZ py3o.template==0.9.5 \
        && npm install -g less \
        && apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing wkhtmltopdf \
        && apk del .build-deps

# create the odoo user
RUN adduser -D -g "" odoo
RUN mkdir -p /opt/odoo/data
RUN mkdir -p /opt/odoo/etc
RUN mkdir -p /opt/odoo/extra-addons
RUN mkdir -p /opt/odoo/var
RUN chown -R odoo /opt/odoo/*
#RUN chown -R odoo /opt/odoo/etc
#RUN chown -R odoo /opt/odoo/extra-addons
#RUN chown -R odoo /opt/odoo/data

# Execution environment
USER odoo
CMD /opt/odoo/files/odoo/odoo-bin -c /opt/odoo/etc/odoo.conf
