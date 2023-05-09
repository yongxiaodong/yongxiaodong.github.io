## 主要需要解决以下3个问题  
- 本地网络与Kubernetes集群网络的直接连通  
- 在本地实现Kubernetes中内部服务的DNS解析  
- 将对集群中其它Pod访问的流量转移到本地  

![img_1.png](img_1.png)
##本地主动调用线上svc服务（不涉及线上主动回调本地）：  
1、下载ktctl.exe： http://sr.ffquan.cn/ops/ktctl.exe  
2、将ktctl放入环境变量  
3、powershell输入命令开启test1环境的全局代理： ktctl -n test1 connect --setupGlobalProxy  
4、尝试直接通过K8S service名字，直接调用线上服务  

## 线上服务直接回调本地服务  
- 将名为dtk-go-app-api的服务转发到本地，输入命令：ktctl exchange dtk-go-app-api --expose 8080  