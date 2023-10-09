

/usr/lib/systemd/system 中添加${serviceName}.service文件。写入
```
[Unit]
Description=srerobot #必填
After=network.target
[Service]
Type=simple
# User=root 
# Group=root
# Environment=LD_LIBRARY_PATH=/usr/local/miniconda3/lib:$LD_LIBRARY_PATH #环境变量,特殊场景才需要申明
PIDFile=/var/log/srerebot.pid  #pid文件
ExecStart=/usr/local/python3.8/bin/python3.8 /usr/local/python3.8/scripts/SrePrince/bin/sreprince.py #启动命令
ExecStop=/bin/kill -TERM $MAINPID
TimeoutStopSec=5
KillMode=mixed
Restart=always  # 托管重启
LimitNOFILE=100000
LimitNPROC=100000
[Install]
WantedBy=multi-user.target
```

生效  
```
systemctl daemon-reload
systemctl start ${service_name}
systemctl status ${service_name}
systemctl restart ${service_name}
```

>> ExecStart处必须写绝对路径



----

## 一键生成一个名为v2r的服务示例
```

tsname='v2r'
cat << EOF >> /usr/lib/systemd/system/${tsname}.service
[Unit]
Description=${tsname} 
After=network.target
[Service]
Type=simple
PIDFile=/var/log/${tsname}.pid 
ExecStart=/data/soft/XrayR --config /data/soft/config.yml
TimeoutStopSec=5
KillMode=mixed
Restart=always 
LimitNOFILE=100000
LimitNPROC=100000
[Install]
WantedBy=multi-user.target
EOF

## 启动
systemctl daemon-reload
systemctl enable ${tsname} --now
systemctl status ${tsname}

```