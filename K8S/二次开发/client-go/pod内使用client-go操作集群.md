


### 集群内控制器pod通过client-go操作集群

需要导入包
```
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
```
操作Deployment
```
# 集群内控制器初始配置
config, err := rest.InClusterConfig()
	if err != nil {
		gres.Status = 401
		return gres
	}
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		gres.Status = 571
		return gres
	}
	# 获取Deployment的信息
	dp, err := clientset.AppsV1().Deployments(data.SelectedImage.Namespace).Get(context.TODO(), data.DpName, metav1.GetOptions{})
	# 更新资源
    _, err = clientset.AppsV1().Deployments(data.SelectedImage.Namespace).Update(context.TODO(), dp, metav1.UpdateOptions{})
	

```