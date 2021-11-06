#!/bin/bash

HOME=/root/deployment

###### INSTALL APACHE2 ######

apt update
apt install apache2 -y
systemctl enable apache2
cp -v $HOME/application-deployment/dir.conf /etc/apache2/mods-enabled/dir.conf
systemctl restart apache2

###### INSTALL PHP ######

apt install -y php libapache2-mod-php
cp $HOME/application-deployment/index.php /var/www/html/index.php
cp $HOME/application-deployment/info.php /var/www/html/info.php

###### ###### 
###### ###### 
