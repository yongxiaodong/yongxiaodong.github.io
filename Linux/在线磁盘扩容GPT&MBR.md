### 常见的分区类型
- MBR
- GPT
#### MBR
适用于小磁盘，最大支持2TB的磁盘
#### GPT
适用于大磁盘，理论最大支持8z

### 常见的文件系统类型
- ext4
- xfs

### 分区类型和文件系统的关系  
- 分区是物理磁盘上的逻辑区域，记录着起始位置和激素位置，它是文件系统的载体  
- 文件系统负责管理分区上的数据存储和访问，为数据提供了一个逻辑结构，比如目录、路径等。使操作系统可以对数据读写
- 如果对分区做了变更操作以后，文件系统会受到影响，需要进行相应的调整和格式化。通常修改分区大小后，需要扩展文件系统才能使用新分配的空间

### 基础知识
#### 查看分区类型
`fdisk -l`中的Disk label Type值表示分区的类型， 对应关系如下:  
- gpt (gpt分区)
- dos (MBR分区)

`type sgdisk || sudo yum install -y gdisk && gdisk -l /dev/vdc `查看GPT磁盘的相信信息
####  创建GPT分区
```
parted /dev/vdc
print
unit s  # 按扇区显示容量
mkpart data 2048s 100% # 创建一个名为data的分区，从2048扇区开始，100%分配
quit
#mkfs.xfs /dev/vdc1  # 格式化为xfs文件系统格式
```
#### 查看分区是否4K对齐
`parted  /dev/vdc print` 查看start位置是否从1049K开始
`fdisk -l` 查看start start 位置是否是4的倍数


### 分区在线扩容
不管是MBR还是GPT，都只能扩容磁盘中最后一个分区
> CentOS 6要用文章最后的parted离线扩容否则有分区表被破坏的风险

#### MBR格式在线扩容
```
type growpart || sudo yum install -y cloud-utils-growpart
sudo yum update cloud-utils-growpart
sudo LC_ALL=en_US.UTF-8 growpart /dev/vdb 1
```
#### GPT格式在线扩容
```
type growpart || sudo yum install -y cloud-utils-growpart
sudo yum update cloud-utils-growpart
type sgdisk || sudo yum install -y gdisk  #需要gdisk支持
sudo LC_ALL=en_US.UTF-8 growpart /dev/vdb 1 
```

### 文件系统在线扩容

#### ext4
 `resize2fs /dev/vdb1`

#### xfs
`xfs_growfs  /dev/vdb1`


#### GPT分区离线扩容
```
parted /dev/vdc
print
resizepart 1 100%
quit
```
##### 常见警告
分区表没有到磁盘的末尾，可能会导致在别的操作系统中认为这个磁盘更小，可以使用Fix修复  
```
Error: The backup GPT table is not at the end of the disk, as it should be.  This might mean that another operating system believes the disk is smaller.  Fix, by moving the backup to the end (and removing the
old backup)?
Fix/Ignore/Cancel? Fix
```
创建分区时没有4k对齐的性能警告  
```
Warning: The resulting partition is not properly aligned for best performance.
Ignore/Cancel? Cancel 
```
分区表（GPT）没有使用磁盘上所有可用的空间，可以使用Fix修复
```
Warning: Not all of the space available to /dev/vdc appears to be used, you can fix the GPT to use all of the space (an extra 41943040 blocks) or continue with the current setting?
```

### MBR转GPT
安装命令工具依赖  
`type sgdisk || sudo yum install -y gdisk`  
-g 代表conver mbr to gpt   
`sgdisk -g /dev/vdb`  