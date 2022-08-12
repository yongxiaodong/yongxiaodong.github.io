

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