
>> 注入Nginx的Location 配置


```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/server-snippet: |
      location ~* "/7j5CiHAFWF.txt" {
          return 200 "7311110d02bd078c08be575456dddeda";
       }
```


>> ingress nginx controller 生成后的配置


```
# in ingress nginx controll 
bash-5.1$ cat nginx.conf  | grep -C3  txt
		}
		
		# Custom code snippet configured for host single.zhetuitui.com
		location ~* "/7j5CiHAFWF.txt" {
			return 200 "7311110d02bd078c08be575456dddeda";
		}

```



>> 注入Lua脚本(做钉钉扫描鉴权示例)

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
    nginx.ingress.kubernetes.io/proxy-body-size: "100m"
    nginx.ingress.kubernetes.io/auth-url: "http://auth-service.aaa.com/get-access-permission"
    nginx.ingress.kubernetes.io/auth-signin: "https://oapi.dingtalk.com/connect/qrconnect?appid="
    nginx.ingress.kubernetes.io/configuration-snippet: |
      set_by_lua_block $redirecturi {
          local origin_url = ngx.var.scheme .. "://" .. ngx.var.host .. ngx.var.uri
          local redirect_uri = "http://auth-service.aaa.com/get-code?originUrl=" .. origin_url
          return ngx.escape_uri(redirect_uri)
      }
      error_page 419 = @index_api;
      if ( $arg_r ~* "^api" ) {
          return 419;
      }

```