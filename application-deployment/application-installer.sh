#!/bin/bash


echo $DEPLOYEDTAG $NEWTAG 0 >> /root/app-cron

HOME=/root/deployment
TAGFILE=$HOME/application-deployment/apptag

if [ -f "$TAGFILE" ]; then
   DEPLOYEDTAG=$(cat $TAGFILE)
   NEWTAG=$(git rev-parse --short HEAD)
   echo $NEWTAG > $TAGFILE
   echo $DEPLOYEDTAG $NEWTAG 1 >> /root/app-cron
else
   DEPLOYEDTAG=NONE
   NEWTAG=$(git rev-parse --short HEAD)
   echo $NEWTAG > $TAGFILE
   echo $DEPLOYEDTAG $NEWTAG 2 >> /root/app-cron
fi

if [ $DEPLOYEDTAG != $NEWTAG ];then

   echo $DEPLOYEDTAG $NEWTAG 3 >> /root/app-cron


echo "###### UPDATED MOTD ######" >> /root/app-cron

cp -v $HOME/application-deployment/99-application-info /etc/update-motd.d/99-application-info

echo "###### INSTALL APACHE2 ######" >> /root/app-cron

apt update
apt install apache2 -y
systemctl enable apache2
cp -v $HOME/application-deployment/dir.conf /etc/apache2/mods-enabled/dir.conf
systemctl restart apache2

echo "###### INSTALL PHP ######" >> /root/app-cron

apt install -y php libapache2-mod-php
cp -v $HOME/application-deployment/index.php /var/www/html/index.php
cp -v $HOME/application-deployment/info.php /var/www/html/info.php
cp -v $HOME/application-deployment/sl.php /var/www/html/sl.php
cp -v $HOME/application-deployment/sk.php /var/www/html/sk.php
cp -v $HOME/application-deployment/sk.php /var/www/html/testing.php

echo "####### Install NMAP ######" >> /root/app-cron

apt install nmap

fi
