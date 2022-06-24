## 准备工作

```angular2
# 创建filebeat安装目录
mkdir -p /usr/local/elk && cd 

```

## 安装filbeat

1、下载filebeat
```angular2
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.7.1-linux-x86_64.tar.gz
tar xf filebeat-7.7.1-linux-x86_64.tar.gz -C /usr/loca/elk/ && mv /usr/local/elk/filebeat-7.7.1-linux-x86_64 /usr/local/elk/filebeat-7.7.1

```

2、 配置filebeat

```angular2

filebeat.inputs:
- type: log
  enabled: true  # 修改为true表示启用
  paths:
    - /usr/local/server/kuaiban-app-*/logs/app1/*.log  # 配置需要被收集的日志路径
    - /var/log/*.log

output.elasticsearch:
  hosts: ["172.16.2.155:9200"]  # 配置elasticsearch 的地址

```

3、 前台启动filebeat（这里暂时前台启动看看是否正常，也可以配合nohup放入后台运行。文章后面会写通过supervisor管理进程）

`/usr/local/elk/filebeat-7.7.1/filebeat -e -c /usr/local/elk/filebeat-7.7.1/filebeat.yml`




## 附加了解内容：filebeat进阶配置

1、java多行日志收集
例：
```angular2
  multiline:
    pattern: '^\s*(\d{4}|\d{2})\-(\d{2}|[a-zA-Z]{3})\-(\d{2}|\d{4})'   # 指定匹配的表达式
    negate: true                                                       # 是否匹配到
    match: after                                                       # 合并到上一行的末尾
    max_lines: 1000                                                    # 最大的行数
    timeout: 10s                                                       # 如果在规定的时候没有新的日志事件就不等待后面的日志
  fields:                                                                # 添加type字段
      type: "stdout"

```


2、 自定义索引名（默认filebeat发送的数据会通过filebeat-*索引）

```angular2
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["172.16.2.155:9200"]
  index: "30test-environment-%{+yyyy.MM.dd}" # 设置索引名，按天
setup.ilm.enabled: false  # 必须加
setup.template.name: "30test-environment"
setup.template.pattern: "30test-environment-*"

```


3、 解析json
```angular2
processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
  - decode_json_fields:  # 解析json的配置，解析message子弹
      fields: ["message"]
      process_array: false
      max_depth: 3
      target: ""
      overwrite_keys: false
      add_error_key: true
  - rename:  # json字段重命名
      fields:
        - from: "url"
          to: "request_url"
      ignore_missing: false
      fail_on_error: true

```

4、 日志输出到logstash

```angular2
output.logstash:
  hosts: ["172.16.2.155:5044"]

```
