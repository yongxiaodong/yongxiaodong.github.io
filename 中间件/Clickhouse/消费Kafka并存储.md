利用Kafka引擎自动从指定的Kafka中消费数据、并通过关联试图清洗数据写入到存储表中进行数据持久化

案例：Nginx日志json格式化后，通过filebeat推送到Kafka，Clickhouse自动消费kafka中的日志，并存储分析

### 定义kafka消费引擎表
消费表字段需要跟Kafka中的字段一致
```
CREATE TABLE nginx_log.nginx_log
(
`access_time` DateTime,
`remote_addr` String,
`x_forward_for` String,
`http_x_forwarded_for` String,
`request_method` String,
`request_uri_path` String,
`request_uri` String,
`status` UInt64,
`request_time` Float32,
`upstream_host` String,
`upstream_response_length` String,
`upstream_response_time` String,
`upstream_status` String,
`http_referer` String,
`remote_user` String,
`http_user_agent` String,
`appkey` String,
`upstream_addr` String,
`http_host` String,
`pro` String,
`request_id` String,
`bytes_sent` UInt64
)
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka_node:9092,kafka_node2:9092', kafka_topic_list = 'sre-log-collector', kafka_group_name = 'sre-clickhouse-2', kafka_format = 'JSONEachRow', kafka_row_delimiter = '\n', kafka_num_consumers = 4, date_time_input_format = 'best_effort'
```


### 定义持久化的存储表
存储表的字段，在视图表中关联写入

```
CREATE TABLE nginx_log.nginx_logstore
(
`access_time` DateTime,
`remote_addr` String,
`x_forward_for` String,
`http_x_forwarded_for` String,
`request_method` String,
`request_uri_path` String,
`request_uri` String,
`status` UInt64,
`request_time` Float32,
`upstream_host` String,
`upstream_response_length` String,
`upstream_response_time` String,
`upstream_status` String,
`http_referer` String,
`remote_user` String,
`http_user_agent` String,
`appkey` String,
`upstream_addr` String,
`http_host` String,
`pro` String,
`request_id` String,
`bytes_sent` UInt64
)
ENGINE = MergeTree
PARTITION BY toYYYYMMDD(access_time)
ORDER BY access_time
SETTINGS index_granularity = 8192
```

### 视图表，从引擎表将数据写入存储表

```
CREATE MATERIALIZED VIEW nginx_log.nginxlog_to_nginxstore TO nginx_log.nginx_logstore
(
`access_time` DateTime,
`remote_addr` String,
`x_forward_for` String,
`http_x_forwarded_for` String,
`request_method` String,
`request_uri_path` String,
`request_uri` String,
`status` UInt64,
`request_time` Float32,
`upstream_host` String,
`upstream_response_length` String,
`upstream_response_time` String,
`upstream_status` String,
`http_referer` String,
`remote_user` String,
`http_user_agent` String,
`appkey` String,
`upstream_addr` String,
`http_host` String,
`pro` String,
`request_id` String,
`bytes_sent` UInt64
) AS
SELECT *
FROM nginx_log.nginx_log
SETTINGS date_time_input_format = 'best_effort'
```