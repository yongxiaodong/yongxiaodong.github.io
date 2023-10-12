## Squid正向代理

需求： 代理部分Windows终端的部分流量，指定使用squid  
方案：Windows代理时使用PAC白名单代理部分流量，部署基于用户验证的squid服务  

### 服务端

#### 安装squid
```
yum install squid
yum install httpd
```

####  生成用户密码文件
```
htpasswd -c /etc/squid/passwd $username # $username 填用户名，回车后会提示输入密码
```

#### 配置基于用户验证的squid
在/etc/squid/squid.conf中添加
```
auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/passwd #用户密钥文件
auth_param basic children 5 # 验证次数
auth_param basic realm Welcome # 提示信息
auth_param basic credentialsttl 2 hours # 用户登录凭据过期时间

acl auth_users proxy_auth REQUIRED # 为允许身份验证的用户定义Squid身份验证 ACL

http_access allow auth_users # 仅允许通过登录验证的用户使用代理

```

### 客户端

> 1、仅代理1.1.1.1和baidu.com域名  
> 2、文件必须放到http服务器上进行引用
 
PAC白名单文件样例:  
```
function FindProxyForURL(url, host) {
  if (shExpMatch(url,"*baidu.com*")) {
    return "PROXY 47.93.12.112:3128";
  }
  if (shExpMatch(url,"*1.1.1.1*")) {
    return "PROXY 47.93.12.112:3128";
  }
  return "DIRECT";
}
```

win10 -> 设置 -> 网络和Internet -> 代理 -> 自动设置代理 -> 自动检测设置打开填入脚本的http地址（PAC不能放本地）  
