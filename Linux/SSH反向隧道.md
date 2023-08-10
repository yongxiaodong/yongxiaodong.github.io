
> 场景： 本地机器无公网IP，但是希望将具有公网IP的服务器A的80端口请求转发到本地机器的9099端口  
### 方案一
```
A服务器执行：sudo sed -i '/^#GatewayPorts/a GatewayPorts yes' /etc/ssh/sshd_config && systemctl restart sshd  
本地执行：ssh -N -R 80:localhost:9099 root@8.137.11.188  
```

### 方案二
```
本地执行：ssh -N -R 81:localhost:9099 root@8.137.11.188  
A服务器执行： ssh -L 0.0.0.0:80:localhost:81 root@localhost  
```
