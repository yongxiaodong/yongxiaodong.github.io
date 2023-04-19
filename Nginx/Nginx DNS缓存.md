
## Nginx DNS缓存问题
本文解决Nginx proxy_pass中DNS不会动态解析的问题

当Nginx中存在如下类似配置时,配置中静态配置的域名(foo.example.com)只会在启动（或重新加载配置）时查找DNS一次，然后就永久缓存。  
```
proxy_pass http://foo.example.com;
```  
所以当我们更新了foo.example.com的DNS解析记录时，Nginx不会再次解析域名，仍然会往旧的解析地址转发请求，导致请求异常。  


## Nginx DNS动态查找
可以通过如下方式避免，Resolver仅用于带变量的proxy_pass，即  
```
resolver 114.114.114.114 ipv6=off valid=5s;
set $backend "foo.example.com";
proxy_pass http://$backend;
```
在这样的配置中，foo.example.com的IP地址将会被动态查询，结果将会被缓存5s