### 创建local PV
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: local-storage-1 #定义local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer # 定义使用时绑定
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-local-1
spec:
  capacity:
    storage: 330Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage-1
  local:
    path: /esdata/  
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - cn-beijing.192.168.16.25  #指定节点
---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-local-2
spec:
  capacity:
    storage: 330Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage-1
  local:
    path: /esdata/  
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - cn-beijing.192.168.24.232
```


在statefulset中使用local PV

```
  ... 省略
        ## 挂载
          volumeMounts:
        - name: data
          mountPath: /usr/share/elasticsearch/data
 ... 省略
  # 使用上面申明的local pv，通过storageClassName识别
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: local-storage-1
      resources:
        requests:
          storage: 330Gi
```