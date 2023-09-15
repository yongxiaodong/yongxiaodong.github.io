
## 安装warp  
- 通过1.1.1.1找到对应系统版本的warp部署  
- 例： rhel 8 版本： https://pkg.cloudflareclient.com/#rhel
```
wget git.io/warp.sh && chmod +x warp.sh # 下载脚本
warp.sh proxy # 启动代理端口
```


## 将warp端口进行公网共享(非必要)
```

# 将0.0.0.0:40001转发到127.0.0.1:40000
iptables -t nat -A PREROUTING -p tcp --dport 40001 -j DNAT --to-destination 127.0.0.1:40000

# 开启访问白名单
iptables -I INPUT -p tcp --dport 40000  -s 192.168.1.1 -j ACCEPT
iptables -A INPUT -p tcp --dport 40000  -j REJECT

service iptables save
```

## XrayR配置部分域名通过warp代理

#### 自定义custom_outbound.json文件

修改socks5-warp处的servers为warp监听的端口  
```
[
  {
    "tag": "IPv4_out",
    "protocol": "freedom",
    "settings": {
    }
  },
  {
    "tag": "IPv6_out",
    "protocol": "freedom",
    "settings": {
      "domainStrategy": "UseIPv6"
    }
  },
  {
    "tag": "socks5-warp",
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 40000
        }
      ]
    }
  },
  {
    "protocol": "blackhole",
    "tag": "block"
  }
]
```


定义需要通过warp的域名： 编辑route.json 在socks5-warp处添加代理的域名  
- 此处我添加了openai的域名和几个查询IP的域名  

```
{
  "domainStrategy": "IPOnDemand",
  "rules": [
    {
      "type": "field",
      "outboundTag": "block",
      "ip": [
        "geoip:private"
      ]
    },
    {
      "type": "field",
      "outboundTag": "block",
      "protocol": [
        "bittorrent"
      ]
    },
    {
      "type": "field",
      "outboundTag": "socks5-warp",
      "domain": ["ifconfig.me", "chat.openai.com", "whatismyipaddress.com", "ip138.com"]
    },
    {
      "type": "field",
      "outboundTag": "IPv6_out",
      "domain": [
        "geosite:netflix"
      ]
    },
    {
      "type": "field",
      "outboundTag": "IPv4_out",
      "network": "udp,tcp"
    }
  ]
}
```

#### 在主配置文件中引用自定义的文件

编辑config.yml中这两项取消注释，并修改自定义的配置文件路径
```
RouteConfigPath: /data/soft/route.json # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
OutboundConfigPath: /data/soft/custom_outbound.json
```



