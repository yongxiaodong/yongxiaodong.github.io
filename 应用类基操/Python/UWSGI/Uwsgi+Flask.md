## 安装Uwsgi

```
pip install uwsgi

```

uwsgi.ini
```
[uwsgi]
socket = 0.0.0.0:9099
chdir = /usr/local/nginx/html/vip_itgod/
#module = vip_itgod.wsgi.py
wsgi-file = /usr/local/nginx/html/vip_itgod/vip_itgod/wsgi.py
master = true
vhost = true
no-site = true
workers = 2
reload-mercy = 10
vacuum = true
max-requests = 1000   
limit-as = 512
buffer-size = 30000
#pidfile = /var/run/uwsgi9090.pid    //pid文件，用于下面的脚本启动、停止该进程
daemonize = /usr/local/nginx/html/vip_itgod/uwsgi9090.log
pythonpath = /usr/local/python3/lib/python3.6/site-packages/


```

