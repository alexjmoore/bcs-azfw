#!/bin/bash
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
apt-get update && apt-get install -y apache2 php libapache2-mod-php
mkdir /var/www/site
cp src/* /var/www/site
cp apache-config.conf /etc/apache2/sites-enabled/000-default.conf
systemctl restart apache2
