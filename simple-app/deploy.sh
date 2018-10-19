#!/bin/bash
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
echo installing Apache
apt-get update && apt-get install -y apache2 php libapache2-mod-php
echo deploying Application
mkdir /var/www/site
cp src/* /var/www/site
cp apache-config.conf /etc/apache2/sites-enabled/000-default.conf
echo storing region
LOCATION=`curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/location?api-version=2017-08-01&format=text"`
echo SetEnv HTTP_LOCATION "$LOCATION" > /var/www/site/.htaccess
echo restarting Apache
systemctl restart apache2
