bpftrace是一个基于BPF的跟踪器，它提供了一种高级编程语言(类似与awk命令)，可以创建强大的单行命令和短脚本


## Centos7 install

```
curl https://repos.baslab.org/rhel/7/bpftools/bpftools.repo --output /etc/yum.repos.d/bpftools.repo
yum install bpftrace bpftrace-tools bpftrace-doc bcc-static bcc-tools
```



跟踪新进程并查看参数  
`bpftrace  -e 'tracepoint:syscalls:sys_enter_execve {join(args->argv);}'`

按进程统计系统调用的次数
`bpftrace -e 'tracepoint:syscalls:sys_enter_* { @[probe] = count();}`
