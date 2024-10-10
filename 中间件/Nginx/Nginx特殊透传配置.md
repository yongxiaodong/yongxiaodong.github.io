## 配置默认的Cache-control策略，以更好的控制CDN缓存


>  从后端读取返回的header头中的cdn_time字段，如果有就设置为Cache-Control的时间，没有就设置-1  
   
nginx.conf  
```
    map $sent_http_cdn_time $expires {
        default             -1;
        ~^\d+$               $sent_http_cdn_time;
    }
    expires            $expires;
    more_set_headers   "Upstream-Name: $proxy_host";

```

> 由于有上面全局的expires设置，如果取不到cdn_time就会设置为不缓存，针对某些特殊场景后端返回的是Cache-Control，使用如下配置将Cache-Control透传
   
xxx.server.conf
```
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|swf|svg)$ {
            header_filter_by_lua_block {
                local cache_control_header = ngx.resp.get_headers()["Cache-Control"]
                if cache_control_header == nil  or cache_control_header == "" then
                    ngx.header["Cache-Control-Tag"] = "proxy_default"
                    ngx.header["Cache-Control"] = "max-age=864000"
                    ngx.header["Cdn-Time"] = "864000"
                else
                    ngx.header["Cache-Control-Tag"] = "pass_through"
                    ngx.header["Cache-Control"] = cache_control_header
                    local max_age_str = string.match(cache_control_header, "%d+")
                    if max_age_str then
                        cdn_time = max_age
                        ngx.header["Cdn-Time"] = max_age_str
                    else
                        ngx.header["Cdn-Time"] = -1
                    end
                end
            }
        proxy_pass http://$backend;
    }
```