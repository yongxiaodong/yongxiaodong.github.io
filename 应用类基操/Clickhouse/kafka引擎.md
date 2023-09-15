## 创建kafka消费引擎  
> 可以直接从kafka从消费数据  
- 指定Kafka地址、topic、消费组名称  
- 指定kafka中每个json数据的类型  
```
CREATE TABLE kafka_data
(
    link String,
    requestTime DateTime,
    ip String,
    status Int32,
    x_cache String,
    size_response String,
    apiName String,
    appKey String,
)
ENGINE = Kafka()
SETTINGS
    kafka_broker_list = '192.168.14.101:9092',
    kafka_topic_list = 'yuan_api',
    kafka_group_name = 'clickhouse',
    kafka_format = 'JSONEachRow';
```


## 创建数据表  
> 用于存储实际的数据  
- 指定分区键，通过解析requestTime获取分区键，格式为YYYYMMDD

```
CREATE TABLE data
(
    link String,
    requestTime DateTime,
    ip String,
    status Int32,
    x_cache String,
    size_response String,
    apiName String,
    appKey String
)
ENGINE = MergeTree()
ORDER BY (requestTime)
PARTITION BY toYYYYMMDD(requestTime);
```

## 创建关联视图

> 将消费的kafka数据关联到数据表中  

- 将数据插入到数据表中

```
CREATE MATERIALIZED VIEW orders_mv TO data AS
SELECT
    link,
    CAST(requestTime AS DateTime) AS requestTime,
    ip,
    status,
    x_cache,
    size_response,
    apiName,
    appKey
FROM kafka_data;
```