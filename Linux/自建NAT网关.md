
# NAT网关配置
### 打开转发功能
```
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
sysctl -p
````
## 配置iptables

> 配置nat表，所有来源通过192.168.16.70这个IP代理出去
```
iptables -t nat -I POSTROUTING -s 0.0.0.0/0 -j SNAT --to-source 192.168.16.70
```

# 客户端配置
## 其他主机默认路由指向NAT
```

```