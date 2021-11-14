I have completed the first challenge, I will start on the second challenge on Saturday. Please review the following and let me know if you have any questions. 



1) The First issue, as a DevOps, I start troubleshooting with basics such as checking the CPU utilization, memory, disk usage & utilization, so after I logged in, I immediately checked the disk usage and found the problem. 

df -h command was showing that root partition was 100% full, and du command was giving a different output. We run into this issue a lot on our on-prem systems at Yahoo! and the quickest way to fix this issue is to restart the service. This is how I resolved the issue. 


df -h 
/dev/xvda1      7.7G  7.7G     0 100% /

du -h --max-depth=1 /
root@ip-172-31-255-9:/etc/apache2# du -h --max-depth=1 / 
431M	/snap
15M	/sbin
48K	/tmp
4.0K	/srv
0	/sys
40M	/boot
4.0K	/opt
16K	/lost+found
111M	/lib
du: cannot access '/proc/9742/task/9742/fd/4': No such file or directory
du: cannot access '/proc/9742/task/9742/fdinfo/4': No such file or directory
du: cannot access '/proc/9742/fd/3': No such file or directory
du: cannot access '/proc/9742/fdinfo/3': No such file or directory
0	/proc
15M	/bin
762M	/usr
4.0K	/mnt
4.0K	/media
4.0K	/lib64
6.1M	/etc
48K	/root
28K	/home
420M	/var
0	/dev
756K	/run
1.8G	/


Also, received this message "cannot create temp file for here-document: No space left on device".  

 root@ip-172-31-255-9:/# lsof -nP | grep '(deleted)'
 none       1527                   root  txt       REG                0,1       8632      24587 / (deleted)
 named      1540                   root    3w      REG              202,1 7061491712      55384 /tmp/tmp.W1bVnnpArh (deleted)
 
 root@ip-172-31-255-9:/# kill -9 1540

 root@ip-172-31-255-9:/# df -h 
 Filesystem      Size  Used Avail Use% Mounted on
 udev            224M     0  224M   0% /dev
 tmpfs            48M  1.4M   47M   3% /run
 /dev/xvda1      7.7G  1.2G  6.6G  15% /
 tmpfs           238M     0  238M   0% /dev/shm
 tmpfs           5.0M     0  5.0M   0% /run/lock
 tmpfs           238M     0  238M   0% /sys/fs/cgroup
 /dev/loop0       98M   98M     0 100% /snap/core/9993
 /dev/loop1       29M   29M     0 100% /snap/amazon-ssm-agent/2012
 tmpfs            48M     0   48M   0% /run/user/0
 root@ip-172-31-255-9:/# 
 
 
2) Second issue, I wasn't able to install the apache2 package, then I found out the host was not able to communicate with the outside network. Restarted systemd-resolved.service. Once the service was up, I was able to install the apache2 service. Following are the steps I took to resolve the issue. 
 
 
 root@ip-172-31-255-9:/# ping www.yahoo.com 
 ping: www.yahoo.com: Temporary failure in name resolution
 
 
 root@ip-172-31-255-9:/# systemctl restart systemd-resolved.service
 root@ip-172-31-255-9:/# systemctl status systemd-resolved.service
 ● systemd-resolved.service - Network Name Resolution
    Loaded: loaded (/lib/systemd/system/systemd-resolved.service; disabled; vendor preset: enabled)
    Active: active (running) since Thu 2021-11-04 19:31:19 UTC; 7s ago
      Docs: man:systemd-resolved.service(8)
            https://www.freedesktop.org/wiki/Software/systemd/resolved
            https://www.freedesktop.org/wiki/Software/systemd/writing-network-configuration-managers
            https://www.freedesktop.org/wiki/Software/systemd/writing-resolver-clients
  Main PID: 23918 (systemd-resolve)
    Status: "Processing requests..."
     Tasks: 1 (limit: 536)
    CGroup: /system.slice/systemd-resolved.service
            └─23918 /lib/systemd/systemd-resolved

 Nov 04 19:31:19 ip-172-31-255-9 systemd[1]: Stopped Network Name Resolution.
 Nov 04 19:31:19 ip-172-31-255-9 systemd[1]: Starting Network Name Resolution...
 Nov 04 19:31:19 ip-172-31-255-9 systemd-resolved[23918]: Positive Trust Anchors:
 Nov 04 19:31:19 ip-172-31-255-9 systemd-resolved[23918]: . IN DS 19036 8 2 49aac11d7b6f6446702e54a1607371607a1a41855200fd2ce1cdde32f24e8fb5
 Nov 04 19:31:19 ip-172-31-255-9 systemd-resolved[23918]: . IN DS 20326 8 2 e06d44b80b8f1d39a95c0b0d7c65d08458e880409bbc683457104237c7f8ec8d
 Nov 04 19:31:19 ip-172-31-255-9 systemd-resolved[23918]: Negative trust anchors: 10.in-addr.arpa 16.172.in-addr.arpa 17.172.in-addr.arpa 18.172.in-addr.arpa 19.172.in-addr.arpa 20.172.in-addr.arpa 21.172.in-addr.arpa 22.172.in-addr.arpa 23.172.in-addr.arpa 24.172.in-addr.arpa 2
 Nov 04 19:31:19 ip-172-31-255-9 systemd-resolved[23918]: Using system hostname 'ip-172-31-255-9'.
 Nov 04 19:31:19 ip-172-31-255-9 systemd[1]: Started Network Name Resolution.
 lines 1-21/21 (END)


 root@ip-172-31-255-9:/# ping www.yahoo.com 
 PING new-fp-shed.wg1.b.yahoo.com (74.6.231.20) 56(84) bytes of data.
 64 bytes from media-router-fp73.prod.media.vip.ne1.yahoo.com (74.6.231.20): icmp_seq=1 ttl=41 time=28.4 ms
 64 bytes from media-router-fp73.prod.media.vip.ne1.yahoo.com (74.6.231.20): icmp_seq=2 ttl=41 time=30.5 ms
 ^C
 --- new-fp-shed.wg1.b.yahoo.com ping statistics ---
 2 packets transmitted, 2 received, 0% packet loss, time 1001ms
 rtt min/avg/max/mdev = 28.439/29.491/30.543/1.052 ms

 
 
 
3) Third issue -- I installed the apache2 package, but it was not starting up. I saw this message "could not bind to address [::]:80". Which meant that some other service is using port 80. I ran netstat to find the pid, killed the pid, and restarted apache. 
 
 
 root@ip-172-31-255-9:/etc/apache2# systemctl status apache2.service
 ● apache2.service - The Apache HTTP Server
    Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
   Drop-In: /lib/systemd/system/apache2.service.d
            └─apache2-systemd.conf
    Active: failed (Result: exit-code) since Thu 2021-11-04 19:41:30 UTC; 18s ago
   Process: 3790 ExecStart=/usr/sbin/apachectl start (code=exited, status=1/FAILURE)

 Nov 04 19:41:30 ip-172-31-255-9 systemd[1]: Starting The Apache HTTP Server...
 Nov 04 19:41:30 ip-172-31-255-9 apachectl[3790]: (98)Address already in use: AH00072: make_sock: could not bind to address [::]:80
 Nov 04 19:41:30 ip-172-31-255-9 apachectl[3790]: (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:80
 Nov 04 19:41:30 ip-172-31-255-9 apachectl[3790]: no listening sockets available, shutting down
 Nov 04 19:41:30 ip-172-31-255-9 apachectl[3790]: AH00015: Unable to open logs
 Nov 04 19:41:30 ip-172-31-255-9 apachectl[3790]: Action 'start' failed.
 Nov 04 19:41:30 ip-172-31-255-9 apachectl[3790]: The Apache error log may have more information.
 Nov 04 19:41:30 ip-172-31-255-9 systemd[1]: apache2.service: Control process exited, code=exited status=1
 Nov 04 19:41:30 ip-172-31-255-9 systemd[1]: apache2.service: Failed with result 'exit-code'.
 Nov 04 19:41:30 ip-172-31-255-9 systemd[1]: Failed to start The Apache HTTP Server.
 root@ip-172-31-255-9:/etc/apache2# 

 

 
 root@ip-172-31-255-9:/etc/apache2# sudo netstat -ltnp | grep ':80'
 tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      1534/nc             


 root@ip-172-31-255-9:/etc/apache2# ps -wlp1534
 F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
 4 S     0  1534     1  0  80   0 -  3398 inet_c ?        00:00:00 nc

 root@ip-172-31-255-9:/etc/apache2# kill -9 1534

 root@ip-172-31-255-9:/etc/apache2# sudo netstat -ltnp | grep ':80'

 root@ip-172-31-255-9:/etc/apache2# systemctl stop apache2.service

 root@ip-172-31-255-9:/etc/apache2# systemctl restart apache2.service

root@ip-172-31-255-9:/etc/apache2# sudo netstat -ltnp | grep ':80'
tcp6       0      0 :::80                   :::*                    LISTEN      7627/apache2     
 
 
 
 
 4) Fourth issue, even though apache was running, but I was not able to pull the landing page. 
 
 a. Following ncat command was hanging
 root@ip-172-31-255-9:/etc/apache2# nc -zv localhost 80 

 
 b. I ran the following command and noticed that it's showing tcp6. 
  
 root@ip-172-31-255-9:/etc/apache2# netstat -plntu
 Active Internet connections (only servers)
 Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
 tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      23918/systemd-resol 
 tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1474/sshd           
 tcp6       0      0 :::80                   :::*                    LISTEN      5815/apache2        
 tcp6       0      0 :::22                   :::*                    LISTEN      1474/sshd           
 udp        0      0 127.0.0.53:53           0.0.0.0:*                           23918/systemd-resol 
 udp        0      0 172.31.255.9:68         0.0.0.0:*                           613/systemd-network 
 
 
c. Then I ran the following command to confirm if it was responding for ipv6

 root@ip-172-31-255-9:/etc/apache2# nc -zv localhost 80 -6
 Connection to localhost 80 port [tcp/http] succeeded!
 
 
d. I updated /etc/apache2/ports.conf with Listen 0.0.0.0:80, but still it was hanging 


e. I installed nmap and saw that port-80 is filtered 

 root@ip-172-31-255-9:/etc/apache2# nmap -sS 127.0.0.1 -p 80

 Starting Nmap 7.60 ( https://nmap.org ) at 2021-11-04 20:42 UTC
 Nmap scan report for localhost (127.0.0.1)
 Host is up.

 PORT   STATE    SERVICE
 80/tcp filtered http
 
 f. I removed following from iptables "iptables -D INPUT -p tcp -m tcp --dport 80 -j DROP"
 
 e. curl http://54.221.87.39/ (Page loaded)
 
 g. curl -I

root@ip-172-31-255-9:/etc/apache2# curl -I http://54.221.87.39/
HTTP/1.1 200 OK
Date: Thu, 04 Nov 2021 22:29:27 GMT
Server: Apache/2.4.29 (Ubuntu)
Last-Modified: Thu, 04 Nov 2021 19:32:15 GMT
ETag: "2aa6-5cffb957ca821"
Accept-Ranges: bytes
Content-Length: 10918
Vary: Accept-Encoding
Content-Type: text/html

h. root@ip-172-31-255-9:/etc/apache2# nc -vz localhost 80 
Connection to localhost 80 port [tcp/http] succeeded!
root@ip-172-31-255-9:/etc/apache2# 

