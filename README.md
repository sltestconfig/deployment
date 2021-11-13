**Configuration Management tool**

I have created a configuration management tool, which can install, configure and maintain any number of servers. The configurations are on git repo, the server will pull the git repo every 10 minutes and will compare the "git commit" tag and if its a new tag then it will apply the changes.

**Bootstrap instructions**

1) cd root
2) git clone https://github.com/sltestconfig/deployment.git
3) cd deployment;git pull
4) /root/deployment/server-configuration/bootstrap.sh
5) cat /var/spool/cron/crontabs/root
6) Cron runs every 10 minutes and if there is a new git tag, then it will update server

**Features**

1) Add all application installation and configuration on git 
2) Add any MOTD from a central location to all the servers
3) Admin Tool - /usr/bin/sladmin - To Stop, Start, Status, File Info, Install and Remove Package. This is just a concept. 

**How to use it?**

1) Go to https://github.com/sltestconfig/deployment
2) Under application-deployment folder, you can make changes to following

   - application-installer.sh (This is where I am installing apache, php, configuring apache, restarting application)
   - Update MOTD 99-application-info
