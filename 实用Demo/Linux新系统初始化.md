# for shell
```
#!/bin/bash
#2017/1/17
#stop service
for offser in ip6tables iptables Bluetooth postfix cups cpuspeed NetworkManager vsftpd dhcpd nfs nfslock ypbind rpcbind portreserve xinted
	do
		service $offser stop &> /dev/null
			if [ $? -eq 0 ];then
				echo "stop $offser success"
			else
				echo "stop $offser false"
			fi
	done
#set ntp address
grep ^server /etc/ntp.conf | head -1 | xargs -i sed -i "/^{}.*$/i server 10.109.192.35 iburst" /etc/ntp.conf && echo 'add iburst ntp address success'
grep ^server /etc/ntp.conf | head -1 | xargs -i sed -i "/^{}.*$/i server 10.109.192.12 prefer" /etc/ntp.conf && echo 'add prefer ntp address success'
#set selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config && echo 'stop selinux success'
#set vlan yum
mkdir /etc/yum.repos.d/bak
mv /etc/yum.repos.d/* /etc/yum.repos.d/bak/
echo -e "[a]\nname=b\nbaseurl=ftp://10.176.24.118/pub/redhat6.8/\nenabled=1\ngpgcheck=0" > /etc/yum.repos.d/vlan.repo && echo 'add yum success'
#lock user
for offuser in deamon bin sys adm uucp nuucp printq guest nobody lpd sshd
	do
		usermod -L $offuser 2> /dev/null
			if [ $? -eq 0 ];then
				echo "usermod -L $offuser success"
			else
				echo "usermod -L $offuser false"
			fi
	done
#disabled service 
for offservice in finger telnet sendmail time echo discard daytime chargen comsat klogin kshell ntalk talk tftp uucp dtspc smb ip6tables cups   portreserve rpcbind postfix NetworkManager bluetooth vsftpd dhcpd nfslock rpcbind portreserve xinted
	do
		chkconfig --level 123456 $offservice off 2> /dev/null
			if [ $? -eq 0 ];then
				echo "chkconfig --level 123456 $offservice off success"
			else
				echo "chkconfig --level 123456 $offservice off false"
			fi
	done
#start service
for onservice in sshd ntpd ntpdate cman clvmd rgmanager ricci luci
	do
		chkconfig --level 123456 $onservice on 2> /dev/null
			if [ $? -eq 0 ];then
				echo "chkconfig --level 123456 $onservice on success"
			else
				echo "chkconfig --level 123456 $onservice on false"
			fi
	done
#delete suid sgid
for desuid in /usr/bin/chage /usr/bin/gpasswd /usr/bin/wall /usr/bin/chfn /usr/bin/chsh /usr/bin/newgrp /usr/bin/write /usr/sbin/usernetctl /bin/mount /bin/umount /sbin/netreport
	do
		chmod a-s $desuid 2> /dev/null
			if [ $? -eq 0 ];then
				echo "chmod a-s $desuid success"
			else
				echo "chmod a-s $deduis false"
			fi
		
	done
#no modification
#for chafile in /etc/passwd /etc/shadow /etc/group /etc/gshadow
#	do
#		chattr +i $chafile 2> /dev/null
#			if [ $? -eq 0 ];then
#				echo "chattr $chafile success"
#			else
#				echo "chattr $chafile false"
#			fi
#	done

#lock file
for lockfile in /etc/audit/auditd.conf /var/log/audit/audit.log /var/log/messages /var/log/cron /var/log/secure /etc/syslog.conf
	do
		chmod 640 $lockfile 2> /dev/null
			if [ $? -eq 0 ];then
				echo "chmod 640 $lockfile success"
			else
				echo "chmod 640 $lockfile false"
			fi
		
	done
for locklog in /var/log/spooler /var/log/mail /var/log/boot.log /var/log/localmessages
	do 
		chmod 774 $locklog 2> /dev/null
			if [$? -eq 0 ];then
				echo "chmod 774 $locklog success"
			else
				echo "chmod 774 $locklog false"
			fi
	done
mkdir /var/adm
echo '''*.err,kern,debug,daemon,notice,mail,crit /var/adm/messages''' >> /etc/rsyslog.conf

#su
mv /etc/pam.d/su /etc/pam.d/su.bak
echo "auth    sufficient    pam_rootok.so">>/etc/pam.d/su
echo "auth    required     pam_wheel.so group=wheel">>/etc/pam.d/su
cat /etc/pam.d/su.bak >>/etc/pam.d/su
chmod 644 /etc/pam.d/su
chmod 644 /etc/pam.d/su.bak
#set ctrl+alt_del
cp -v /etc/init/control-alt-delete.conf /etc/init/control-alt-delete.override
sed -i '/^start/'d /etc/init/control-alt-delete.conf && echo "delete control-alt-delete"
sed -i '/^exec.*$/d' /etc/init/control-alt-delete.conf 
echo 'exec /usr/bin/logger -p authpriv.notice -t init "Ctrl-Alt-Del was pressed and ignored"' >> /etc/init/control-alt-delete.conf && echo "modify control-alt-delete"
#banner infomation
echo 'Banner /etc/issur.net' >> /etc/ssh/sshd_config && echo 'set Banner info'
sed -i '1'd /etc/issue.net && echo 'delte issue.conf info'
sed -i '/^.*$/i Warning: ATTENTION:Youhaveloggedontoasecuredserver!/' /etc/issue.net && echo 'add issue.conf info'
#password security policy
sed -i 's/^.*PASS_MAX_DAYS.*[0-9]$/PASS_MAX_DAYS 90/g' /etc/login.defs && echo 'modify pass_max_day 90'
sed -i 's/^.*PASS_MIN_DAYS.*[0-9]$/PASS_MIN_DAYS 0/g' /etc/login.defs && echo 'modify pass_min day 0'
sed -i 's/^.*PASS_MIN_LEN.*[0-9]$/PASS_MIN_LEN 12/g' /etc/login.defs && echo 'modify pass_min_len 12'
sed -i 's/^.*PASS_WARN_AGE.*[0-9]$/PASS_WARN_AGE 7/g' /etc/login.defs && echo 'modify pass_warn_age 7'
sed -i '/^password.*type=$/i Password requisite pam_cracklib.so ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 try_first_pass retry=3 type=' /etc/pam.d/system-auth && echo 'password strength policy'
sed -i '/^#%PAM.*$/a auth   required pam_tally2.so deny=5 unlock_time=300' /etc/pam.d/system-auth && echo "local login lock user policy"
sed -i '/^#%PAM.*$/a auth  required   pam_tally2.so even_deny_root deny=5 unlock_time=300' /etc/pam.d/sshd && echo "ssh login lock user policy"
#time out 
echo 'export TMOUT=600' >> /etc/profile && echo 'timtou policy'
#modify ssh port
sed -i 's/^#Port.*22$/Port 10022/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
service sshd reload
service ntpd start &> /dev/null
#chage -M 91 root
#SP1 set
echo "IP=\`ifconfig  | grep 'inet addr:' | awk '{print \$2}' | awk -F':' '{print \$2}' | sed -e '/^10.*$/'p -ne '/^22.*$/'p -e '/^20.*/'p | head -n1\`" >> /etc/bashrc
sed -i '/^.*\[.*\=.*\&\&.*$/'d /etc/bashrc
echo '[ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h:$IP:\w]\\$ "' >> /etc/bashrc
#su set
useradd weblogic
echo 'Ptyw1q2w3e$R' | passwd --stdin weblogic
sed -i '/^.*root.*ALL=(ALL).*ALL$/a weblogic ALL=NOPASSWD:ALL,!/bin/su' /etc/sudoers
echo 'Ptyw1q2w3e$R' | passwd --stdin root
setenforce 0
echo 'ulimit -n 65535' >> /etc/profile
```