## 基础申明  

下文中的模块简写依赖这里的命名  
```
local cjson =  require "cjson"
local ngx_log = ngx.log
local ngx_err = ngx.ERR
local redis = require "resty.redis"
local uri = ngx.var.uri
local red = redis:new()
local args = ngx.req.get_uri_args()
```


## 函数申明
```
local mess_return = function(mess, s)
    if s == nil then
        ngx.status = 200
    else
        ngx.status = s
    end
    ngx_say(cjson.encode(mess))
    ngx.exit(0)
end

-- 调用mess_return函数
if not appkey  then
        local mess = {}
        mess["message"] = "appkey不存在"
        mess_return(mess, 439)
end
```


## if判断语法


基础判断 

```
if not appKey then
    -- logic
else
    -- logic
end

```

uid[1]是userdata类型，不能直接和lua自带的nil对比。json中的value如果是null， 经过cjson.decode以后，该value的类型就是userdata，值是ngx.null ， 如果强制转换为字符串，则打印出来的内容是“userdata: null”， 所以decode之后，判断value是否为空的时候，需要和ngx.null比较
```
if uid[1] == ngx.null then
        local mess = {}
        mess["message"] = "appkey不存在"
        mess_return(mess, 439)
end
```


## table 循环  
```
for k,v in pairs(table) do
    -- logic
end
```


## redis 操作

```
-- redis初始化
red:set_timeout(100)
local red_option = {}
red_option["pool_size"] = 50
red_option["backlog"] = 100
local ok, err = red:connect("r-2zejf1hgj2eej5br0x.redis.rds.aliyuncs.com", 6379, red_option)
-- 链接失败则正常退出，让nginx继续执行后面的流程
if not ok then
    ngx.exit(0)
end

local  find_uid = function()
    local res, err = red:hmget(mdw_prefix .. ':' .. appkey, "uid")
    if res then
        -- 成功则放入长链接
        local r, err = red:set_keepalive(100000, 50)
        return res
    else
        local mess = {}
        mess["message"] = "appkey不存在"
        mess_return(mess, 439)
    end
end
-- 调用函数查询redis
local uid = find_uid()
```

## 获取nginx参数

```
-- 获取host
local domain = http_host

-- 获取接口
if uri == "/query_new" then
    -- logic
end

-- 获取uri参数
if args["appKey"] then
    -- logic
end
```


## lua里重置nginx变量  

```
ngx.var.cmspassto = 'cmsnew'
```


## lua HTTP请求

```
ngx.var.cmspassto = 'cmsnew'
 local json = require "cjson.safe"
 local http = require "resty.http"
 local httpc = http:new()
 
 local get_vipstatus = function(appid)
   check_vip_uri="/xxxxx/cms/v1/user-server-status?appId=" .. appid
   local resp,err = httpc:request_uri("http://xxx.fquan.cn",
                           {
                                   method = "GET",
                                   path=check_vip_uri
                           })
   if resp.status >= 500 then
     ngx.say('upstream check vip api error')
   end
   if not resp then
       ngx.say("query vip status err:",err)
       return
   end
   res = resp.body
 --  ngx.log(ngx.ERR, "接收结果打印完成==================================")
   -- 解json
   res_json = json.decode(res)
   vipstatus = res_json["data"]["is_vip"]
   if vipstatus then
     cms_domain_vipstatus_mem:set(appid,vipstatus,300)
     return vipstatus
   end
   ngx.log(ngx.ERR, 'vipstatus 为空')
   return
 end
 
 
 if appid then    
   local vipstatus = cms_domain_vipstatus_mem:get(appid)
   if vipstatus == 1 or vipstatus == '1' then
       -- 修改nginx里的后端变量，nginx里set $cmspassto 'varnish_servers';了这个变量
       ngx.var.cmspassto = 'cmsnew'
   else
       ngx.var.cmspassto = 'cms'
   end
 end

```
