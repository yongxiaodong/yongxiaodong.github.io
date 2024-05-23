
### 二开apisix  ody-tranformer的部分代码  

- apisix body-tranformer默认不支持解码gzip数据，后端返回gzip会导致body乱码甚至解码失败
- 默认不支持上游返回3xx状态时跳过，导致3xx状态码内容被修改
- 利用zzlib实现




在body_filter阶段判断响应数据是否为gzip，并为其添加标识
```
function _M.body_filter(_,ctx)
    -- 省略部分源码
    -- 定义状态码白名单
    local status = ngx.status
    local white_status = { [301] = true, [302] = true, [307] = true, [308] = true }
    local replace
    
    -- 定义状态码标识
    if white_status[status] then
            replace = false
    end
    
    if conf.response and replace then
    -- 省略部分源码
        local body = core.response.hold_body_chunk(ctx)
        if ngx.arg[2] == false and not body then
            return
        end
        -- 开启gzip解码
        if ngx.ctx.isgzip then
            body = zzlib.gunzip(body)
        end
    end

```


在header_filter阶段判断响应数据是否为gzip，并为其添加标识

```
function _M.header_filter(conf,ctx)
        -- 省略部分源码
        set_input_format(conf, "response", ngx.header.content_type)
        -- 判断响应数据是否为gzip，为其添加标识
        local res_header = ngx.resp.get_headers()
        if res_header and res_header["content-encoding"] == "gzip" then
                ngx.ctx.isgzip = true
        end

        core.response.clear_header_as_body_modified()

```