## 注解location

```
nginx.ingress.kubernetes.io/server-snippet: |
    location ~* "/7j5CiHAFWF.txt" {
        return 200 "7311110d02bd078c08be575456dddeda";
    }
```


##  跨域

```
kubectl.kubernetes.io/last-applied-configuration: |
      if ($request_method = 'OPTIONS') {
        add_header 'Access-Control-Max-Age' 1728008;
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Headers' '*';
        add_header 'Access-Control-Allow-Methods' 'GET,POST,PUT,DELETE,PATCH,OPTIONS';
        return 200;
       }
```