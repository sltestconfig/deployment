#!/bin/bash

HOME=/root/deployment
APPTAGFILE=$HOME/application-deployment/apptag

if [ -f "$APPTAGFILE" ]; then
   DEPLOYEDTAG=$(cat $APPTAGFILE)
else
   DEPLOYEDTAG=none
   NEWAPPTAG=$(git rev-parse --short HEAD)
   echo $NEWAPPTAG > $APPTAGFILE
fi



if [ $DEPLOYEDTAG != $NEWAPPTAG ];then

###### UPDATED MOTD ######

cp -v $HOME/application-deployment/99-application-info /etc/update-motd.d/99-application-info

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

fi
