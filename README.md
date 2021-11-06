1) git download bootstrap, that does update the crontab 
2) File listing 
3) Install and remove the package
4) Restart the service 
5) Apply config if the tag changed 


git add *;git commit -m "Building Server deployment & management tool";git push 


**Bootstrap instructions**

1) cd root
2) git clone https://github.com/sltestconfig/deployment.git
3) /root/deployment/server-configuration/bootstrap.sh
4) cat /var/spool/cron/crontabs/root
