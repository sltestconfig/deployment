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

###### UPDATED MOTD ######

cp -v $HOME/application-deployment/99-application-info /etc/update-motd.d/99-application-info

###### INSTALL APACHE2 ######

/usr/bin/apt update
/usr/bin/apt install apache2 -y
systemctl enable apache2
cp -v $HOME/application-deployment/dir.conf /etc/apache2/mods-enabled/dir.conf
systemctl restart apache2

###### INSTALL PHP ######

/usr/bin/apt install -y php libapache2-mod-php
cp -v $HOME/application-deployment/index.php /var/www/html/index.php
cp -v $HOME/application-deployment/info.php /var/www/html/info.php
cp -v $HOME/application-deployment/sl.php /var/www/html/sl.php
cp -v $HOME/application-deployment/sk.php /var/www/html/sk.php
cp -v $HOME/application-deployment/sk.php /var/www/html/testing.php

####### Install NMAP ######

/usr/bin/apt install nmap -y 

fi
