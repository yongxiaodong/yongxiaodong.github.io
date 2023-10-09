
## Headless Service（无头服务） VS 普通Service
Headless
- 无Cluster Ip
- 客户端请求时返回的是每个后端的FQDN地址，客户端可以拿到FQDN来自主决定访问哪一个后端（比如自主决定使用主库 or 从库）

普通SVC
- 有一个Cluster IP，这个Cluster IP理解成iptables（或LVS）的虚拟IP，外部访问该SVC时访问的是这个虚拟IP，该请求应该被路由到哪一个Pod是由iptables决定的

## Headless 应用场景
- 客户端需要自主的选择访问哪一个pod（如主从数据库）
- pod需要进行互相的精准访问（如分布式服务中，A需要和B进行数据同步）


## 应用案错误案例

先声明一个外部的Endpoint
```
apiVersion: v1
kind: Endpoints
metadata:
  name: external-proxysql

subsets:
- addresses:
  - ip: 192.168.11.1
  - ip: 192.168.11.2
  ports:
  - port: 3306
    protocol: TCP
    name: mysql
```
将Endpoint绑定到一个无头服务
```
apiVersion: v1
kind: Service
metadata:
name: external-proxysql

spec:
clusterIP: None
ports:
- port: 6033
  protocol: TCP
  targetPort: 3306
  name: mysql
```

在以上申明后，看似可以在其它pod中访问external-proxysql:6033来实现访问到192.168.11.1:3306端口？


No！

原理分析：
    1、应用尝试请求external-proxysql:6033
    2、Headless服务返回的是FQDN，如mysql-1.default.svc.cluster.local、mysql-2.default.svc.cluster.local
    3、应用自主选择使用某一个FQDN，假设选择了mysql-1.default.svc.cluster.local，然后访问了6033端口，拼接出来的目标FQDN是mysql-1.default.svc.cluster.local:6033，但是mysql-1.default.svc.cluster.local:3306才是正确的服务端口，所以导致访问失败
