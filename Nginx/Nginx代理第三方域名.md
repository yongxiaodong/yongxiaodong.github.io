
### Nginx代理第三方域名需求实现 

请求第三方具有防盗链、防跨域的域名    
例：
- 请求路径: xxx.itgod.org?domain=img.alicdn.com&path=/a.jpg时实际请求的是img.alicdn.com/a.jpg  

```
server{
    listen      80;
    server_name xxx.itgod.org;
    # 解析uri绑定到变量
    set_unescape_uri $decodeed_path $arg_path;
    set_unescape_uri $decodeed_domain $arg_domain;
    resolver 114.114.114.114 ipv6=off valid=5s;

    location / {
        # 这一段不是很重要，可以不要
        proxy_set_header User-Agent  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.37";
        proxy_set_header Accept 'image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8';
        proxy_set_header Accept-Encoding 'gzip, deflate, br';
        proxy_set_header Sec-Ch-Ua-Mobile '?0';
        proxy_set_header Sec-Ch-Ua '"Not.A/Brand";v="8", "Chromium";v="114", "Microsoft Edge";v="114"';
        
        # 伪造来源和请求的域名地址
        proxy_set_header Host $decodeed_domain;
        proxy_set_header Referer '';

        expires off;
        # 发起请求
        proxy_pass https://$decodeed_domain$decodeed_path;
    }
}


```