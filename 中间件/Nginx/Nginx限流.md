## 优势：

Nginx限流可以针对客户端的IP进行请求速率限制，既能够强行保证请求的实时处理速度，又能防止恶意攻击或突发流量导致系统被压垮，提升系统的健壮性。


## 在http模块中新增配置limit_req_zone全局配置

在http模块中新增配置limit_req_zone,如下：
```
http {
    include       mime.types;
    default_type  application/octet-stream;
    server_tokens off;
    limit_req_zone $binary_remote_addr zone=mylimit:10m rate=2r/s;
```

> - $binary_remote_addr表示根据remote_addr变量的值进行限制
> - zone=mylimit:10m 表示一个大小为10M，名字为myRateLimit的内存区域，根据官方描述，1M的内存大约可以存储16000个IP地址，10M则可以存储约16万IP地址，可以根据实际情况调整
> - rater=2r/s 表示限制每秒2个请求，Nginx 实际上以毫秒为粒度来跟踪请求信息，因此 2r/s 实际上是限制：每500毫秒处理一个请求。这意味着，自上一个请求处理完后，若后续500毫秒内又有请求到达，将拒绝处理该请求，默认返回503错误码，该错误码可以自定义。


## 在server中调用limit_req_zone

例：
```
    server {
        listen       8089;
        server_name  localhost;
        root html/shigongbao;
        autoindex on;
        limit_req zone=mylimit burst=4 nodelay;
        location / {
            index  index.html index.htm;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
 }
```

> - zone=mylimit 表示调用http全局模块中定义的limit_req_zone zone名
> - burst=4 表示缓冲区突然流量处理，在超过设定的处理速率后能额外处理的请求数。当 rate=2r/s 时，将1s拆成2份，即每500ms可处理1个请求。 当同时有10个请求到达时，rate=2 立刻转发了2个请求到后端服务器，burst=4 缓存或立刻转发了4个请求（是否立刻转发主要看nodelay参数），丢弃了4个请求
> - Nodelay 针对的是burst参数，burst=4 nodelay 表示这4个请求立马处理，不能延迟，相当于特事特办。不过，即使这4个突发请求立马处理结束，后续来了请求也不会立马处理。burst=4 相当于缓存队列中占了4个坑，即使请求被处理了，这4个位置这只能按 500ms一个来释放。


## 执行ab压力测试

上述配置中rate=2r/s，burst=4，推理出第1秒可以一次性处理5个请求（因为rate=2 500毫秒内的第二个请求会被丢弃）
#### 一次性发送5个请求测试结果，Failed requests:        0
```
[root@cs2 Yearning-go]# ab -n 5 -c 5 http://192.168.1.30:8089/
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 192.168.1.30 (be patient).....done


Server Software:        nginx
Server Hostname:        192.168.1.30
Server Port:            8089

Document Path:          /
Document Length:        394 bytes

Concurrency Level:      5
Time taken for tests:   0.002 seconds
Complete requests:      5
Failed requests:        0
Write errors:           0
Total transferred:      2545 bytes
HTML transferred:       1970 bytes
Requests per second:    2019.39 [#/sec] (mean)
Time per request:       2.476 [ms] (mean)
Time per request:       0.495 [ms] (mean, across all concurrent requests)
Transfer rate:          1003.78 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:     1    1   0.1      1       1
Waiting:        1    1   0.1      1       1
Total:          1    1   0.1      1       1

Percentage of the requests served within a certain time (ms)
  50%      1
  66%      1
  75%      1
  80%      1
  90%      1
  95%      1
  98%      1
  99%      1
 100%      1 (longest request)
```

#### 一次性发送6个请求测试结果，有一个请求被丢弃，Failed requests:        1

```
[root@cs2 Yearning-go]# ab -n 6 -c 6 http://192.168.1.30:8089/
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 192.168.1.30 (be patient).....done


Server Software:        nginx
Server Hostname:        192.168.1.30
Server Port:            8089

Document Path:          /
Document Length:        394 bytes

Concurrency Level:      6
Time taken for tests:   0.018 seconds
Complete requests:      6
Failed requests:        1
   (Connect: 0, Receive: 0, Length: 1, Exceptions: 0)
Write errors:           0
Non-2xx responses:      1
Total transferred:      3226 bytes
HTML transferred:       2464 bytes
Requests per second:    328.62 [#/sec] (mean)
Time per request:       18.258 [ms] (mean)
Time per request:       3.043 [ms] (mean, across all concurrent requests)
Transfer rate:          172.55 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        4    5   0.3      5       5
Processing:     5    5   0.0      5       5
Waiting:        5    5   0.1      5       5
Total:          9    9   0.3     10      10
ERROR: The median and mean for the total time are more than twice the standard
       deviation apart. These results are NOT reliable.

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     10
  75%     10
  80%     10
  90%     10
  95%     10
  98%     10
  99%     10
 100%     10 (longest request)
```

#### Nginx error日志记录被丢弃的包如下：

```
2020/07/29 16:00:08 [error] 4471#0: *895 limiting requests, excess: 4.982 by zone "mylimit", client: 192.168.1.40, server: localhost, request: "GET / HTTP/1.0", host: "192.168.1.30:8089"
```


---

### 生产环境限流实战案例

> 1、首先在nginx.conf的http块下申明内存空间
```
http {
    error_log         /var/log/nginx/error.log;
    access_log        /var/log/nginx/access.log;
    charset       utf-8;
    include       mime.types;
    default_type  application/octet-stream;
    # 限流过程中有IP大客户，为大客户单独设置为限流IP白名单
    geo $whiteIpList {
        default 1;
        59.110.139.118 0;
        101.133.138.27 0;
    }
    map $whiteIpList $binary_remote_addr_limit {
        1 $binary_remote_addr;
        0 "";
    } 
    # 分别为域名、uri中的appkey、客户端二进制IP地址设置不同的zone，不同的rate速度限制
    limit_req_zone $http_host           zone=open_api_domain:50m rate=2500r/s;
    limit_req_zone $arg_appkey          zone=open_api_appkey:50m rate=200r/s;
    limit_req_zone $binary_remote_addr  zone=zone_web_tmp:50m    rate=5r/s;
    limit_req_zone $binary_remote_addr  zone=zone_web:50m        rate=50r/s;
    limit_req_zone $binary_remote_addr  zone=zone_web_yjtg:50m   rate=30r/s;
    limit_req_zone $binary_remote_addr_limit  zone=zone_open_api:50m   rate=40r/s;
    ... 省略
```

> 2、在域名的独立vhosts文件中申明使用哪个zone

```
server {
    server_name openapi.itgod.org;
    listen      80;
    listen      443 ssl;
    access_log  /var/log/nginx/openapi.itgod.org.access.log json;
    error_log   /var/log/nginx/openapi.itgod.org.error.log;
    # 使用域名限制，设置burst预防突发流量，突发流量nodelay 0 延迟发送
    limit_req zone=open_api_domain burst=50 nodelay;
    limit_req zone=open_api_appkey burst=100 nodelay;
    limit_req zone=zone_open_api burst=30 nodelay;
    limit_req_status 429;
    #more_set_headers "Debug-For-Yxd: $arg_appkey";
    ....省略
```