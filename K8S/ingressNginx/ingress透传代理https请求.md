

## 转发https流量到backend  
>> 默认情况下，ingress会终止https请求，通过backend代理到后端时，后端服务只会接收到http请求，通过这个注解可以申明透传https请求到后端

`nginx.ingress.kubernetes.io/ssl-passthrough: "true"`