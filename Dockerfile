FROM clouder/odoo-exec
MAINTAINER Yannick Buron yannick.buron@gmail.com

USER odoo
CMD /opt/odoo/files/odoo/odoo-bin -c /opt/odoo/etc/odoo.conf
