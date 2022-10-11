

/usr/lib/systemd/system 中添加${serviceName}.service文件。写入
```
[Unit]
Description=srerobot #必填
After=network.target
[Service]
Type=simple
PIDFile=/var/log/srerebot.pid  #pid文件
ExecStart=/usr/local/python3.8/bin/python3.8 /usr/local/python3.8/scripts/SrePrince/bin/sreprince.py #启动命令
ExecStop=/bin/kill -TERM $MAINPID
TimeoutStopSec=5
KillMode=mixed
Restart=always
LimitNOFILE=100000
LimitNPROC=100000
[Install]
WantedBy=multi-user.target
```