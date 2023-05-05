### Node中统计每个容器总连接数  

```
#!/bin/bash
if ! command -v jq &>/dev/null; then
    yum install -y jq
fi

printf "| %-150s | %-15s |\n" "名称" "连接数"
docker ps | awk -F' ' '{print $1}' | grep -v CON | xargs -i docker inspect {} | jq -r '"\(.[0].State.Pid) \(.[0].Name)"' |
while read line; do
    pid=`echo $line | awk -F' ' '{print $1}'`
    name=`echo $line | awk -F' ' '{print $2}'`
    r=`nsenter -t $pid -n netstat -anptu | wc -l`
    printf "| %-150s | %-15s |\n" "$name" "$r"
done

```


### 查找所有Node中所有的Docker容器连接中包含`192.168.0.15`关键字的  

```
#!/bin/bash
if ! command -v jq &>/dev/null; then
    yum install -y jq
fi


printf "| %-150s | %-15s |\n" "名称" "指定关键词连接数"
docker ps | awk -F' ' '{print $1}' | grep -v CON | xargs -i docker inspect {} | jq -r '"\(.[0].State.Pid) \(.[0].Name)"' |
while read line; do
    pid=`echo $line | awk -F' ' '{print $1}'`
    name=`echo $line | awk -F' ' '{print $2}'`
    r=`nsenter -t $pid -n netstat -anptu | grep  -e '192.168.0.15' -e '192.168.0.17' |wc -l`
    if [ "$r" -gt 0 ]; then
      printf "| %-150s | %-15s |\n" "$name" "$r"
    fi
done
```