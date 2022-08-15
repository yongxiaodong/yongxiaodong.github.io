## 准备
1、安装目录准备

`mkdir -p /usr/local/elk`

## Logstash安装配置

1、下载解压Logstash
```angular2
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.7.1.tar.gz

tar xf logstash-7.7.1.tar.gz -C /usr/local/elk/
```

2、 定义Logstash 配置文件


> grok debug 网站：https://grokdebug.herokuapp.com/
###### > 一个示例：

```
cat config/test.yml 
input {
# 从5044端口接收数据
    beats {
        port => 5044
    }
}


filter {
# 按照正则提取日志
    grok {
        match => [
            "message", "%{TIMESTAMP_ISO8601:time}\s*%{LOGLEVEL:loglevel}\s*---\s*(?<javaclass>.*?)\s*:\s*(?<datainfo>.*)"
        ]

    }
# 替换掉json数据前后的"号
    mutate {
        gsub => [
            "datainfo", "\"{", "{",
            "datainfo", "}\"", "}"
            ]
# 字段重命名            
        rename => [
            "host", "server",
            "method", "java_method"
        ]
# 移除字段            
        remove_field => ["message"]
    }
# 解析json，并将解析的所有json放到  datainfo_group下  
    json {
        source => "datainfo"
        target => "datainfo_group"
    }
    

}

# 输出到elasticsearch
output {
    elasticsearch {
        hosts => ["172.16.2.155:9200"]
        index => "logstash-%{+YYYY.MM.dd}"
    }
    
}



```
