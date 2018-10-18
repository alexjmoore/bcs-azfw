#!/bin/bash
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
echo installing Apache
apt-get update && apt-get install -y apache2 php libapache2-mod-php
echo deploying Application
mkdir /var/www/site
cp src/* /var/www/site
cp apache-config.conf /etc/apache2/sites-enabled/000-default.conf
echo restarting Apache
systemctl restart apache2
