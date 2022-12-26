top命令查看CPU使用率、IO等待情况



## 通用准入性能分析60秒  

>> 黄金60秒尝试定位性能异常组件

```
uptime： 识别1分钟、5分钟、15分钟平均值负载
top ： 检查概览
vmstat -SM 1 : 查看运行队列长度、交换和CPU整体使用情况
mpstat -P ALL 1: 查看CPU核心平衡情况
dmesg -T | tail: 查看内核日志，可能包含一些OOM错误
pidstat 1 : 查看每个进程的CPU使用情况

free -m: 查看内存使用情况，包括文件系统缓存

iostat -x 1: 磁盘IO统计，IOPS、吞吐量、平均等待时间和忙碌百分比

sar -n DEV 1 : 网络设置IO、数据包和吞吐量
sar -n TCP,ETCP 1 ： TCP统计，连接率和重传

```

## 第一步： 跟踪、明确切入点

- 根据观测数据分析  
  如果CPU使用率中，io等待高，应尝试切入到IO性能排查(识别iowait高不一定是IO问题,iowait的计算方式是CPU idle时有多少时间在等待IO)  


## 第二步： 性能开销定位

### CPU性能剖析  

- 概念明确
> CPU负载高和CPU使用率高是不同的两个概念(比如`w`或者`sar -q`看到的`load average`是CPU负载)

通过原生top命令，然后按p通过CPU使用率排序，尝试定位高CPU开销进程

- 一般正常进程都可以直接通过top看到明显的cpu消耗比例
- 如果是木马类隐藏的进程，通过top是看不到的,可以尝试使用htop和busybox top命令（这里涉及到一个top的原理，top是通过遍历/proc/<PID>的方式去统计每个进程对CPU的消耗，如果这个进程没有在/proc下生成pid，那么top是统计不到的）  
- 用户进程可以使用perf定位性能开销函数`https://www.itgod.org/archives/113  

- 火焰图


### IO性能开销定位

- iostat -x 1 查看IO负载和当前iops
- pidstat -d 1 展示io统计
- fio 磁盘性能测试  
`fio -direct=1 -iodepth=32 -rw=randwrite -ioengine=libaio -bs=4k -numjobs=4 -time_based=1 -runtime=1000 -group_reporting -filename=./a -name=test`
  








