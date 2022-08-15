

## 获取huise名称空间下的所有deployment(client.InNamespace可以不指定)
```
func (r *SnapshotReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	log2 := log.FromContext(ctx)
	var dp appsv1.DeploymentList
	if err := r.Client.List(ctx, &dp, client.InNamespace("huise")); err != nil {
		log2.Error(err, "unable fetch dp")
	}
	for _, v := range dp.Items {
		log2.Info(fmt.Sprintf("%s -- %s \n", v.Name, v.Namespace))
	}
	eturn ctrl.Result{}, nil
}
```


###  设置Annotations

为指定的资源设置Annotations，这简单且非常有用，比如控制器操作完资源后，应该添加一个Annotations，用于注释这个资源
已经被操作过了，避免控制器重复操作。
```
sp.SetAnnotations(map[string]string{"Snapshot": "true"})
```


### 判断指定的资源是否存在  

设置查询结构dpname，将查询结果绑定到dp
```
	var dp appsv1.Deployment
	for _, v := range res {
		log2.Info(fmt.Sprintf("%s -- %s=%s", v.DpName, v.ContainerName, v.ContainerImage))
		dpname := types.NamespacedName{
			Namespace: v.NameSpace,
			Name:      v.DpName,
		}
		if err := r.Get(ctx, dpname, &dp); err != nil {
			return ctrl.Result{}, nil
		
```

### 资源绑定删除

比如开发的控制器创建了一个svc和一个ingress，我们可以通过setownerreference关联这两个资源，
在删除这个GVK的时候，我们的所有资源都会一并自动删除  

`controllerutil.SetOwnerReference方法`



### 更新资源

```
    # 为spr对象设置了一个annotations，并将这个对象传给Update方法进行集群更新
	spr.SetAnnotations(map[string]string{"Snapshot": "true"})
	if err := r.Update(ctx, &spr); err != nil {
		return ctrl.Result{}, err
	}
```