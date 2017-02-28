FROM clouder/odoo-exec:0.10.1
MAINTAINER Yannick Buron yannick.buron@gmail.com

USER odoo
CMD /opt/odoo/files/odoo/odoo-bin -c /opt/odoo/etc/odoo.conf
