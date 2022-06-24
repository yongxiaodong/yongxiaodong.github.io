### 查看网卡信息

```nmcli connection

NAME UUID TYPE DEVICE

ens33 a92fa07b-9b68-4d2b-a2e7-e55146099b1b ethernet ens33

ens36 418da202-9a8c-b73c-e8a1-397e00f3c6b2 ethernet ens36

nmcli con xxx
```

### 显示具体的网络接口信息

`nmcli connection show xxx`

### 显示所有活动连接

`nmcli connection show --active`

### 删除一个网卡连接

`nmcli connection delete xxx`

### 给xxx添加一个IP（IPADDR）

`nmcli connection modify xxx ipv4.addresses 192.168.0.58`

### 给xxx添加一个子网掩码（NETMASK）

`nmcli connection modify xxx ipv4.addresses 192.168.0.58/24`

### IP获取方式设置成手动（BOOTPROTO=static/none）

`nmcli connection modify xxx ipv4.method manual`

### 添加一个ipv4

`nmcli connection modify xxx +ipv4.addresses 192.168.0.59/24`

### 删除一个ipv4

`nmcli connection modify xxx -ipv4.addresses 192.168.0.59/24`

### 添加DNS

`nmcli connection modify xxx ipv4.dns 114.114.114.114`

### 删除DNS

`nmcli connection modify xxx -ipv4.dns 114.114.114.114`

### 添加一个网关（GATEWAY）

`nmcli connection modify xxx ipv4.gateway 192.168.0.2`

### 可一块写入：

`nmcli connection modify xxx ipv4.dns 114.114.114.114 ipv4.gateway 192.168.0.2`


### 使用nmcli重新回载网络配置

`nmcli c reload`

### 如果之前没有xxx的connection，则上一步reload后就已经自动生效了

`nmcli c up xxx`

