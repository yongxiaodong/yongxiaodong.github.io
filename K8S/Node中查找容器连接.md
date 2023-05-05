### 统计每个容器总连接数
```
#!/bin/bash
if ! command -v jq &>/dev/null; then
    yum install -y jq
fi
docker ps | awk -F' ' '{print $1}' | grep -v CON | xargs -i docker inspect {} | jq -r '"\(.[0].State.Pid) \(.[0].Name)"' |
while read line; do
    pid=`echo $line | awk -F' ' '{print $1}'`
    name=`echo $line | awk -F' ' '{print $2}'`
    r=`nsenter -t $pid -n netstat -anptu | wc -l`
    echo -e "\033[31mName: $name \033[0m 连接数: $r"
done
```


### 查找所有Node中所有的Docker容器连接中包含`192.168.0.15`关键字的
```
#!/bin/bash
if ! command -v jq &>/dev/null; then
    yum install -y jq
fi
docker ps | awk -F' ' '{print $1}' | grep -v CON | xargs -i docker inspect {} | jq -r '"\(.[0].State.Pid) \(.[0].Name)"' |
while read line; do
    pid=`echo $line | awk -F' ' '{print $1}'`
    name=`echo $line | awk -F' ' '{print $2}'`
    r=`nsenter -t $pid -n netstat -anptu | grep  -e '192.168.0.15' -e '192.168.0.17'`
    if [ -n "$r" ]; then
      echo -e "\033[31mName: $name \033[0m"
      echo $r
    fi
done

```