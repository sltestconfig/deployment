#!/bin/bash

(crontab -l && echo "*/10 * * * * cd /root;git clone https://github.com/sltestconfig/deployment.git;cd /root/deployment;git pull;/root/deployment/server-configuration/bootstrap.sh;/root/deployment/application-deployment/application-installer.sh") | crontab -
