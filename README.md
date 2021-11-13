**Configuration Management tool**

I have created a configuration management tool to install, configure and maintain


and use it to configure two servers for production service of a simple PHP web application. You are not allowed to use off-the-shelf tools like (but not limited to) Puppet, Chef, Fabric, or Ansible. Instead, we would like you to implement a tool a bit like Puppet or Chef that meets the following specifications and then use that tool to configure the two servers.



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
