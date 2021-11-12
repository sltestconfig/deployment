#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
sleep 30
(crontab -l && echo "*/10 * * * * cd /root;git clone https://github.com/sltestconfig/deployment.git;cd /root/deployment;git pull;/root/deployment/application-deployment/application-installer.sh") | crontab -
