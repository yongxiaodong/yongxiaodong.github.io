## 准备工作

> 注意：本篇文章只在集群中添加了2个节点，一般集群为了防止脑裂发生，节点数量会采用基数，比如3个节点

1、确保RabbitMQ机器之间可以通过主机名解析，添加hosts解析


## 普通集群搭建

1、将主节点(node1)的.erlang.cookie 文件复制到各个节点上，保证 /root/.erlang.cookie文件一致

2、在node2上执行命令 加入到node1的集群

> 确保可以通过node-1解析到主节点

```
rabbitmq-server -detached
rabbitmqctl stop_app
rabbitmqctl join_cluster --ram rabbit@node-1
rabbitmqctl start_app
```

3、查看集群状态

```
rabbitmqctl cluster_status
```
> 注意看以下命令输出结果中的Running Nodes是否显示了已加入集群的节点
> 至此，普通集群创建完成

## 镜像集群创建

1、在任意节点执行命令创建同步策略
```
rabbitmqctl set_policy ha-all "^.*" '{"ha-mode":"all"}'
```

    参数解释：
        ha-all为策略名称。
        ^为匹配符，只有一个^代表匹配所有，^zlh为匹配名称为zlh的 exchanges 或者 queue。
        ha-mode为匹配类型，分为 3 种模式：
        all所有（所有的queue）
        exctly部分（需配置ha-params参数，此参数为int类型比如3，众多集群中的随机3台机器）
        nodes指定（需配置ha-params参数，此参数为数组类型比如["rabbit@node-1","rabbit@node-2",,"rabbit@node-3"]这样指定为3台机器。）
        
2、查看策略

```
rabbitmqctl list_policies
```

3、 附加：WEb页面创建 or 查看策略

登录web页面--> Admin--> policies 可以查看和添加策略


## 负载均衡（详细操作方法此处不累述LB常识）

1、可以使用阿里云SLB，调度5672端口即可

2、可以使用Haproxy+keepalived，调度5672端口即可
