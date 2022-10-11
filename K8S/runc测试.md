## 编译

runc不提供二进制包，需要克隆仓库自己编译(依赖go环境)
runc仓库地址： `https://github.com/opencontainers/runc.git`

```
git clone --depth 1 https://github.com/opencontainers/runc.git
cd runc
make
sudo make install
```


## 创建OCI bundle

```
# create the top most bundle directory
mkdir /mycontainer
cd /mycontainer

# create the rootfs directory
mkdir rootfs
# 根据busybox生成config.json
docker export $(docker create busybox) | tar -C rootfs -xvf -
```



## 运行容器

`runc run mycontainerid`

>> 比如内存控制，实际上是通过/sys/fs/cgroup/memory/容器名称/limit文件限制内存使用

