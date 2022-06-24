> 一键安装脚本来源：https://github.com/Nyr/openvpn-install

## 安装
wget https://git.io/vpn -O openvpn-install.sh && bash openvpn-install.sh

##安装选项

```
Welcome to this OpenVPN road warrior installer!

Which IPv4 address should be used?
     1) 172.16.2.155
     2) 172.18.0.1
     3) 172.17.0.1

This server is behind NAT. What is the public IPv4 address or hostname?

Which protocol should OpenVPN use?
   1) UDP (recommended)
   2) TCP

What port should OpenVPN listen to?

Select a DNS server for the clients:
   1) Current system resolvers
   2) Google
   3) 1.1.1.1
   4) OpenDNS
   5) Quad9
   6) AdGuard
Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017

Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017

Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017

An updated CRL has been created.
CRL file: /etc/openvpn/server/easy-rsa/pki/crl.pem
..............................


Finished!

The client configuration is available in: /root/yongxiaodong.ovpn
New clients can be added by running this script again.
```

> 以上执行完成后就自动启动了openVPN服务，ovpn 客户端配置在/root/目录下，配置文件在/etc/openvpn/目录中

### windows客户端安装使用（详细使用方法见11. 远程管理方式）

客户端下载url：https://swupdate.openvpn.org/community/releases/openvpn-install-2.4.8-I602-Win10.exe

下载后安装，并将 服务器上 "用户.ovpn" 文件 copy到客户端安装目录中的config目录即可使用（用户.ovpn文件是通过重新执行openvpn-install.sh中新增用户获得）


### Linux客户端安装使用：

yum install epel-release

yum install openvpn

将 .ovpn 文件放置/etc/openvpn/connect_aliyun目录中

> Linux客户端启动

nohup openvpn /etc/openvpn/connect_aliyun/test_environment.ovpn > /etc/openvpn/connect_aliyun/log.log &

openvpn /etc/***.ovpn

openvopenvpn /etc/***.ovpnpn /etc/***.ovpn

openvpn /etc/***.ovpn

openvpn /etc/***.ovpn

## 安装完成后的调优 （非必须，根据实际情况调整，以下是我实际应用中整理的优化方案）
server.conf 优化
```
local 172.16.2.155
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA512
tls-crypt tc.key
topology subnet
server 10.8.0.0 255.255.255.0
#push "redirect-gateway def1 bypass-dhcp"   # 此行如果不禁用，客户端所有的流量均会通过openVPN代理，为了提高实际使用体验，禁用此行，并在下面自定义需要通过openVPN走的的路由
ifconfig-pool-persist ipp.txt
push "dhcp-option DNS 100.100.2.136" # 此处两行表示要客户端vpn拨号后，推送这两个DNS给客户端，根据实际情况配置，也可以使用公共DNS
push "dhcp-option DNS 100.100.2.138"
keepalive 10 120
cipher AES-256-CBC
user nobody
group nobody
persist-key
persist-tun
status openvpn-status.log
verb 3
crl-verify crl.pem
explicit-exit-notify

# 以下路由是根据我的实际环境中需要通过openVPN经过的流，第一条表示172.16.0.0/16网段流量通过openVPN代理，后面两条是DNS(配置的阿里云的DNS，方便通过阿里云内网域名链接RDS等)

push "route 172.16.0.0 255.255.0.0 vpn_gateway"
push "route 100.100.2.136 255.255.255.255 vpn_gateway"
push "route 100.100.2.138 255.255.255.255 vpn_gateway"
```


## client-common.txt优化

```
client
dev tun
proto udp
remote 47.108.25.212 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA512
cipher AES-256-CBC
#ignore-unknown-option block-outside-dns # 经测试如果不禁用这两行，客户端拨号后无法使用DNS解析
#block-outside-dns
verb 3
```


## 最后

- 修改完配置文件要重启进程（systemctl restart openvpn-server@server）
- 在执行安装脚本的时候创建的用户.ovpn配置中会包含gnore-unknown-option block-outside-dns配置，需要手动编辑取消，否则DNS解析无效
- 删除、新增用户，重新执行安装脚本openvpn-install.sh即可