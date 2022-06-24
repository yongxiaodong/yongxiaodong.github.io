## pv-pvc.yml

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: jenkins
spec:
  capacity:
    storage: 200Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: v1
  nfs:
    path: /
    server: 19fb4b48551-qxp55.cn-chengdu.nas.aliyuncs.com
  mountOptions:
  - nfsvers=4.0

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jenkins
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 200Gi
  storageClassName: v1
  volumeName: jenkins

```

RBAC
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins-admin       #ServiceAccount名
  namespace: jenkins     #指定namespace，一定要修改成你自己的namespace
  labels:
    name: jenkins
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: jenkins-admin
  labels:
    name: jenkins
subjects:
  - kind: ServiceAccount
    name: jenkins-admin
    namespace: jenkins
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io

```


## deployment

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins
  namespace: jenkins
spec:
  selector:
    matchLabels:
      app: jenkins
  replicas: 1
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      terminationGracePeriodSeconds: 10
      serviceAccount: jenkins-admin
      containers:
      - name: jenkins
        image: jenkins/jenkins:lts
        imagePullPolicy: IfNotPresent
        securityContext:
          runAsUser: 0       #设置以ROOT用户运行容器
          privileged: true   #拥有特权
        ports:
        - containerPort: 8080
          name: web
          protocol: TCP
        - containerPort: 50000
          name: agent
          protocol: TCP
        resources:
          limits:
            cpu: 1000m
            memory: 1Gi
          requests:
            cpu: 500m
            memory: 512Mi
        livenessProbe:
          httpGet:
            path: /login
            port: 8080
          initialDelaySeconds: 60
          timeoutSeconds: 5
          failureThreshold: 12 
        readinessProbe:
          httpGet:
            path: /login
            port: 8080
          initialDelaySeconds: 60
          timeoutSeconds: 5
          failureThreshold: 12
        volumeMounts:
        - name: jenkinshome
          subPath: jenkins
          mountPath: /var/jenkins_home
        env:
        - name: LIMITS_MEMORY
          valueFrom:
            resourceFieldRef:
              resource: limits.memory
              divisor: 1Mi
        - name: JAVA_OPTS
          value: -Xmx$(LIMITS_MEMORY)m -XshowSettings:vm -Dhudson.slaves.NodeProvisioner.initialDelay=0 -Dhudson.slaves.NodeProvisioner.MARGIN=50 -Dhudson.slaves.NodeProvisioner.MARGIN0=0.85 -Duser.timezone=Asia/Shanghai
      securityContext:
        fsGroup: 1000
      volumes:
      - name: jenkinshome
        persistentVolumeClaim:
          claimName: jenkins

---
apiVersion: v1
kind: Service
metadata:
  name: jenkins
  namespace: jenkins
  labels:
    app: jenkins
spec:
  type: NodePort
  selector:
    app: jenkins
  ports:
  - name: web
    port: 8080
    targetPort: web
    nodePort: 30000
  - name: agent
    port: 50000
    targetPort: agent

```

## 安装插件
```
因为网络原因需要将jenkins代理设置位置：http://jenkins访问url/pluginManager/advanced

将升级站点处的url地址修改为：http://mirror.xmission.com/jenkins/updates/current/update-center.json

Kubernetes Cli Plugin：该插件可直接在Jenkins中使用kubernetes命令行进行操作。

Kubernetes plugin： 使用kubernetes则需要安装该插件

Kubernetes Continuous Deploy Plugin：kubernetes部署插件，可根据需要使用

http://jenkins访问url/updateCenter/ 查看插件安装进度

```
