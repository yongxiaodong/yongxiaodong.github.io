helm install stable/nfs-client-provisioner --set nfs.server=19fb4b48551-qxp55.cn-chengdu.nas.aliyuncs.com --set nfs.path=/dynamic_sc --name nfs-client-provisioner


## 设置为默认的storageclass
kubectl patch storageclass nfs-client -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'



kubectl get sc