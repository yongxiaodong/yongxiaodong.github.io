
- 解码
```
-- 解码urlencoded,转成了table
      out = ngx.decode_args(body)
-- 解码multipart
     out = ngx.req.get_post_args()

```


