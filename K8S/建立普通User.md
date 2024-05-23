
### 创建用户客户端
``` 
# 创建一个用户秘钥
openssl genrsa -out dev.key 2048
# 生成用户等的csr文件
openssl req -new -key dev.key -out dev.csr -subj "/CN=dev/O=dev"
# 创建用户的私钥并设置有效期为1000天
openssl x509 -req -in dev.csr -CA ./ca.crt -CAkey ./ca.key -CAcreateserial -out dev.crt -days 1000
# 集群内创建用户和生成kubeconfig
kubectl config set-credentials dev --client-certificate=dev.crt  --client-key=dev.key
kubectl config set-context dev-context --cluster=kubernetes --namespace=kube-system --user=dev
```


### 给用户赋只读权限
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: dev-role
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dev-rolebinding
subjects:
- kind: User
  name: dev
  apiGroup: "dev"
roleRef:
  kind: ClusterRole
  name: dev-role
  apiGroup: ""
```


