# client类型  
RESTclient: 最基础的客户端，提供最基础的封装
Clientset: 是client集合。包含所有的K8S内置资源
dynamicClient: 动态客户端，可以操作任意的K8S资源
Doscoveryclinet: 发现KS8提供的资源组，比如kubectl api-reousrces 就是使用了这个类型

# 核心组件

Reflector: list/watch api-server  
Delta FIFO Queue: Reflector将list、atch数据加入队列  
Indexer/Cache: 缓存，数据会与Api server一致，缓解API Server压力，提供了GET/DELETE/LIST等方法存储pod对象。但是比如要获取某个Namespace下所有的POD，我们只能通过pod的对象再进行手动组装数据
Indexer可以通过indexers，indeces、index方法自动建立索引，来解决这个问题

sharedProcessor：
WorkQueue： 通用队列、延迟队列、限速队列。通常直接使用限速队列

![img.png](img.png)
