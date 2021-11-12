#!/bin/bash
sleep 30
(crontab -l && echo "*/10 * * * * cd /root;git clone https://github.com/sltestconfig/deployment.git;cd /root/deployment;git pull;/root/deployment/application-deployment/application-installer.sh") | crontab -
