## 生产消息

> 安装依赖包

`pip install kafka-python`

```
from kafka import KafkaProducer
producer = KafkaProducer(
    bootstrap_servers=['192.168.14.81:9092']
)
for _ in range(100):
    r = producer.send('itgod', b'some_message_bytes%s')
    re = r.get(timeout=5)
    print(re)
producer.close()

```



## 消费消息

```
from kafka import KafkaConsumer

consumer = KafkaConsumer(
    'dataoke2_dtk_users',
    bootstrap_servers='192.168.14.81:9092',
    group_id="py_for_y"

)

for message in consumer:
    print("%s:%d:%d: key=%s value=%s" % (message.topic, message.partition,
                                         message.offset, message.key,
                                         message.value))
```
