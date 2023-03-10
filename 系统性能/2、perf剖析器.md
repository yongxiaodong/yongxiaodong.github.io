# 火焰图 

`yum install perf`

## 采样
使用perf在所有(-a)CPU上以49Hz（-F 49:  每秒采样数） 对栈(-g)跟踪，采样30秒  
`perf record -F 49 -a -g -- sleep 5`

> 建议使用49Hz或者99Hz作为采样频率，避免和某些以100Hz发生的事件合拍，这样可以提高采样的精准度  
> 也可以使用-p选项跟踪单个进程： perf record -F 49 -g -p ${PID}  
> 启动进程的时候并跟踪: perf record -F 999 ./test 


## 生成火焰图  
下面示例采样5秒，然后生成火焰图(out.svg)
```
perf record -F 49 -a -g -- sleep 5; perf script --header > out.stacks
git clone https://github.com/brendangregg/FlameGraph.git; cd  FlameGraph
./stackcollapse-perf.pl < ../out.stacks | ./flamegraph.pl --hash > out.svg
```

>>> Linux 5.8中加入了火焰图报告功能，将上面的原始火焰图软件组合成了一个命令
`perf scipt report flamegraph`


## 查看剖析报告
`perf report`
> 报告生成来自于源文件perf.data，可以在生成火焰图前使用report查看  

了解更多： [Perf零侵入应用性能瓶颈分析](https://itgod.org/book/system_security/_book/%E6%B3%BB%E7%BB%9F%E6%80%A7%E8%83%BD/Perf%E9%9B%B6%E4%BE%B5%E5%85%A5%E5%BA%94%E7%94%A8%E6%80%A7%E8%83%BD%E7%93%B6%E9%A2%88%E5%88%86%E6%9E%90.html)

---

# 调用跟踪  

#### 跟踪Mysqld进程的系统调用
`perf trace -p $(pgrep mysqld)`
#### 系统调用内核时间分析, 捕捉3秒
`perf trace -s -p $(pgrep mysqld) -- sleep 3`
> 该输出显示了每个线程系统调用的技术和时间，直接trace进程时，在任何繁忙的应用程序上都会产生大量的输出，-s汇总参数能帮助我们先从汇总信息开始


# IO剖析

`perf trace -e sendto -p $(pgrep mysqld)`
