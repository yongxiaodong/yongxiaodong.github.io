## for shell

```
#!/bin/bash
#Author: yongxiaodong
#Created with May 17,2017
rpm -qa | grep -q expect
if [ $? -ne 0 ];then
        rpm -ivh tcl-8.5.7-6.el6.x86_64.rpm
        rpm -ihv expect-5.44.1.15-5.el6_4.x86_64.rpm
        yum install expect -y
fi

rpm -qa | grep -q expect
if [ $? -ne 0 ];then
	echo "please install expect"
	exit
fi


if [ ! -f "/root/.ssh/id_rsa.pub" ]; then
expect -c "
	spawn ssh-keygen
	expect {
		\"*?id_rsa* \" {set timeout 300; send \"\r\";exp_continue}
		\"*?passphrase*\" {set timeout 300; send \"\r\";exp_continue}
		\"*?passphrase*\" {set timeout 300; send \"\r\";}
		}
  	expect eof"
fi


cat hostsname.txt | while read ipaddr passwd
do
expect -c "
  spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $ipaddr
  expect {
        \"*?yes/no* \" {set timeout 300; send \"yes\r\";exp_continue}
        \"*?password:\" {set timeout 300; send \"$passwd\r\";}
  }
  expect eof"
done

```