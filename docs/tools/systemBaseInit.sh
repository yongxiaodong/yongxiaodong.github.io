#!/bin/bash
#2017/1/17

#stop selinux and firewalld
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config && echo 'stop selinux success'
systemctl stop firewalld
systemctl disabled firewalld


# set max open file
echo "* soft nofile 65535"  >> /etc/security/limits.conf
echo "* hard nofile 65535"  >> /etc/security/limits.conf

#set yum
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#set ctrl+alt_del
cp -v /etc/init/control-alt-delete.conf /etc/init/control-alt-delete.override
sed -i '/^start/'d /etc/init/control-alt-delete.conf && echo "delete control-alt-delete"
sed -i '/^exec.*$/d' /etc/init/control-alt-delete.conf
echo 'exec /usr/bin/logger -p authpriv.notice -t init "Ctrl-Alt-Del was pressed and ignored"' >> /etc/init/control-alt-delete.conf && echo "modify control-alt-delete"
#modify ssh port
#sed -i 's/^#Port.*22$/Port 10022/g' /etc/ssh/sshd_config
#sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
#service sshd reload
#SP1 set
#echo "IP=\`ifconfig  | grep 'inet addr:' | awk '{print \$2}' | awk -F':' '{print \$2}' | sed -e '/^10.*$/'p -ne '/^22.*$/'p -e '/^20.*/'p | head -n1\`" >> /etc/bashrc
#sed -i '/^.*\[.*\=.*\&\&.*$/'d /etc/bashrc
#echo '[ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h:$IP:\w]\\$ "' >> /etc/bashrc