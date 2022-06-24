

### helm 安装
```
 github  下载helm安装包
wget https://get.helm.sh/helm-v2.16.11-linux-amd64.tar.gz
tar xf helm-v2.16.11-linux-amd64.tar.gz
# 解压后直接把helm 复制到/usr/local/bin目录中
cp linux-amd64/helm /usr/local/bin/
# 可以查看helm版本，现在会提示无法连接到服务器tiller，因为还没有部署tiller
helm version 
```

### 安装tiller

```
helm init --upgrade --tiller-image cnych/tiller:v2.14.1

安装完成后默认会在kube-system下运行一个tiller-deploy的容器

再运行helm version 查看helm 和 tiller的版本信息

```

#### 为tiller创建rbac授权

```
cat > helm-rbrc.yml << 'EOF'
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF

```

### 从阿里云镜像仓库部署tiller容器
```
helm init --service-account=tiller --tiller-image=registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.16.1  --history-max 300
# 再次执行helm version 查看版本

helm version
helm list
```

## 如果需要卸载tiller执行以下命令
```
kubectl get -n kube-system secrets,sa,clusterrolebinding -o name|grep tiller|xargs kubectl -n kube-system delete
kubectl get all -n kube-system -l app=helm -o name|xargs kubectl delete -n kube-system
```