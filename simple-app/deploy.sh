#!/bin/sh
apt-get update && apt-get install -y apache2 php libapache2-mod-php
cp example-app/src/* /var/www/site
cp example-app/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
