
### Container  

容器本质上是指受到资源限制、彼此之间相互隔离的若干个进程集合。Cgroup实现资源限制，Namespace实现隔离  

### Container Runtime  

容器运行时是K8S最核心的组件，它将管理容器的整个生命周期, Podman/Docker/Containerd/CRI-O都是容器运行时


### CRI (Container Runtime Interface)  

CRI 是K8S与Container交互的接口，用于Kubernetes和特定的容器实现解耦。由于Docker比K8s更早，所以有Dockershim，后续ContainerD和CRI-O就实现了CRI接口，不需要再使用Dockershim  

### OCI

可以看做是Container Runtime的一个标准,用于运行根据 Open Container Initiative (OCI) 格式打包的应用程序，准确来说是runtime spec  


###  Runc
runc是一个 CLI 工具，用于根据 OCI 规范在 Linux 上生成和运行容器。    


###  CRI-O

根据OCI开发的一个容器运行时，仅为Kubernetes所用 


### 使用Docker时的容器创建流程  

API Server通过grpc发送请求到kubelet，kubelet内置了docker的shim，解析请求后转发到Docker，Docker再转发到Containerd，Containerd再创建Container-shim进程，最后通过runc与Linux 名称空间和资源限制交互，实现容器创建  
可以看到整套流程非常复杂，kubelet完全可以直接跟containerd交互，以此来简化流程提高性能    
>> 为什么有这么复杂的流程？  
K8S定制了OCI规范，要求所有的容器运行时都遵循这个规范，只要你的运行时支持这个规范，就可以直接接入K8S。但是再推出这个规范前，Docker的地位非常高，所有有一些运行时不会自身去实现CRI接口。所以kubelet里内置了docker-shim来支持OCI规范，而后来Docker又独立了containerd，因此调用逻辑复杂



