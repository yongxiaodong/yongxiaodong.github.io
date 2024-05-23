

> 慎用： luajit目前并不能完成pairs的机器码转换，所以效率略低，可以用ipairs替代。也要少写elseif的判断，lua会分析热代码进行转机器码，未知条件会导致效率低

```
 -- condition是key value格式的条件
 -- use_err_template是判断不通过时的处理标记
 
 
 -- 该函数用于递归取子值，比如支持root.key1.key2的子层级判断
function getValueFromTable(A, k)
    local keys = {}
    for key in string.gmatch(k, "[%a%d_]+") do
        table.insert(keys, key)
    end

    local targetValue = A
    for _, key in ipairs(keys) do
        targetValue = targetValue[key]
        if targetValue == nil then
            return nil
        end
    end

    return targetValue
end

-- 省略部分代码 
-- 根据条件取值判断是否成立 
 for k,v in pairs(condition) do
           local realv = getValueFromTable(out,k)
           if realv then
               if realv ~= v then
                   use_err_template = true
               end
           else
                use_err_template = true
           end
       end

```