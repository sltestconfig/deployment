#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

HOME=/root/deployment
TAGFILE=$HOME/application-deployment/apptag

if [ -f "$TAGFILE" ]; then
   DEPLOYEDTAG=$(cat $TAGFILE)
   NEWTAG=$(git rev-parse --short HEAD)
   echo $NEWTAG > $TAGFILE
else
   DEPLOYEDTAG=NONE
   NEWTAG=$(git rev-parse --short HEAD)
   echo $NEWTAG > $TAGFILE
fi

if [ $DEPLOYEDTAG != $NEWTAG ];then

cp -v $HOME/application-deployment/sladmin-config/sladmin /usr/bin/

###### UPDATED MOTD ######

cp -v $HOME/application-deployment/motd-config/99-application-info /etc/update-motd.d/99-application-info

###### INSTALL APACHE2 ######

/usr/bin/apt update
/usr/bin/apt install apache2 -y
systemctl enable apache2
cp -v $HOME/application-deployment/apache2-config/dir.conf /etc/apache2/mods-enabled/dir.conf
systemctl restart apache2

###### INSTALL PHP ######

/usr/bin/apt install -y php libapache2-mod-php
cp -v $HOME/application-deployment/apache2-config/index.php /var/www/html/index.php
cp -v $HOME/application-deployment/apache2-config/info.php /var/www/html/info.php

####### Install NMAP ######

/usr/bin/apt install nmap -y 

fi
