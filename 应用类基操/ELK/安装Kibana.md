## 准备工作

1、创建安装目录 
`mkdir -p /usr/local/elk`

## 安装kibana

1、下载并解压
```angular2
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.7.1-linux-x86_64.tar.gz

tar xf kibana-7.7.1-linux-x86_64.tar.gz -C /usr/local/elk/
mv /usr/local/elk/kibana-7.7.1-linux-x86_64 /usr/local/elk/kibana-7.7.1

```

2、 配置kibana

```angular2
# cat /usr/local/elk/kibana-7.7.1-linux/config/kibana.yml | grep -v "^#"
server.port: 5601
server.host: "0.0.0.0" # 本地的IP地址0.0.0.0监听所有本地地址
elasticsearch.hosts: ["http://172.16.2.155:9200"]   # elasticsearch的地址和端口
```

3、 使用elastic用户启动kibana

```
/usr/local/elk/kibana-7.7.1//bin/kibana
```

4、 浏览器登陆kibana web页面配置索引
浏览器打开http://172.16.2.155:5601/app/kibana   IP替换为kibana服务器的IP

点击index patterns ---- Create index pattern --- 输入filebeat-* 匹配到filebeat发送到es的日志----next step ---- 完成 

discover查看收集到的日志数据


