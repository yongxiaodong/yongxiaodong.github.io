## rsync

本篇内容名词：

    rsync服务端: 用于接收同步
    
    客户端： 推送到服务器端

> 后续内容会实时将客户端的/usr/local/nginx目录推送到服务端

## 配置rsync服务端置服务端（接收同步数据的机器）

centos默认安装了rsync的rpm包
在同步源机器编辑
vim /etc/rsyncd.conf

```
uid = root
gid = root
use chroot = yes
# address = 172.16.2.155
port 873
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid
hosts allow = 172.16.0.0/16
read only = no

[nginxroot]
path = /root/ansible
dont compress = *.gz *.zip *.bz2 *.rar *.z *.tar
auth users = backuper
secrets file = /etc/rsyncd_users.db
```




2、编辑用户验证文件

`echo 'backuper:pwd@123' > /etc/rsyncd_users.db`

3、设置权限

`chmod 600 /etc/rsyncd_users.db`

3、启动rsync

rsync --daemon
# 查看是否成功启动
netstat -anpt | grep rsync

重启rsync服务命令：
kill `cat /var/run/rsyncd.pid`
rsync --daemon


## 客户端配置：

1、创建密码文件

```
echo 'pwd@123' > /etc/rsync.pass
chmod 600 !$
```

2、测试将本地目录推送到server端

`rsync -az --delete --exclude "logs" /usr/local/nginx/ backuper@172.16.31.109::nginxroot --password-file=/etc/rsync.pass`



3、安装inotify并测试

```
# 结合inotify，安装inotify包
yum install inotify-tools -y
# 监控/backup目录的的状态变更
inotifywait -mrq -e modify,create,move,delete --exclude="logs/" /usr/local/nginx
```

4、 自动运行脚本

```
#!/bin/bash

inotifywait -mrq -e modify,create,move,delete --exclude="logs" /usr/local/nginx | while read DIRECTORY EVENT FILE
do
        if [ `pgrep rsync | wc -l` -le 0 ];then
        	rsync -avz --delete --exclude="logs" /usr/local/nginx/ backuper@172.16.31.109::nginxroot --password-file=/etc/rsync.pass
        fi
	echo '1'
done
```

