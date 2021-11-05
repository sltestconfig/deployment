#!/bin/bash


###### INSTALL APACHE2 ######

apt update
apt install apache2 -y 
systemctl enable apache2
systemctl restart apache2
cp -v dir.conf /etc/apache2/mods-enabled/dir.conf

###### INSTALL PHP ######

apt install -y php libapache2-mod-php
cp index.php /var/www/html/
cp info.php /var/www/html/
