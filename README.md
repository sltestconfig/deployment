**Configuration Management tool**

I have created a configuration management tool, which can install, configure and maintain any number of servers. The configurations are on git repo, the server will pull the git repo every 10 minutes and will compare the "git commit tag" and if its a new "git tag" then it will apply the changes. You can view the logic https://github.com/sltestconfig/deployment/blob/main/application-deployment/application-installer.sh

**Bootstrap instructions**

1) cd root
2) git clone https://github.com/sltestconfig/deployment.git
3) cd deployment;git pull
4) /root/deployment/server-configuration/bootstrap.sh
5) cat /var/spool/cron/crontabs/root (If cron is not visible, then run /root/deployment/server-configuration/bootstrap.sh)
6) Cron runs every 10 minutes and if there is a new git tag, then it will update server

**How to use it?**

1) Go to https://github.com/sltestconfig/deployment
2) Under application-deployment folder, you can make changes to following

   - application-installer.sh (This is where I am installing apache, php, configuring apache, restarting application)
   - sladmin-config/sladmin (This is a concept command line tool to manage the server from the command line)
   - motd-config/99-application-info - Update MOTD 99-application-info, to display the important message
   - If you want to install, remove any package or configuration on the servers, then simply update application-installer.sh

**Features**

1) Add all application installation, removal and configuration steps on git 
2) Add any MOTD from a central location to all the servers
3) Admin Tool - /usr/bin/sladmin - To Stop, Start, Status, File Info, Install and Remove Package. This is just a concept. 


**Completed 2nd challenge - configuration management tool**

1) Bootstrapping the host
2) You can run sladmin file-info filename to see file's content and metadata
3) sladmin allows installing and removing Debian packages
4) On git repo under application-installer.sh, adminstrator can define how to update the configuration and how to restart the service when relevant files or packages are updated
5) Configuration management tool will only apply changes if git repo has a new tag. 
6) Installed Apache and PHP and configured as requested
   - http://18.215.154.152/
   - http://54.242.110.132/
