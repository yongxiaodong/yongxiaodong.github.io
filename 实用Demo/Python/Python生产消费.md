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


## 生产消息（指定多个partition）




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


##消费消息（指定多个partition和消费组名）

```
from kafka import KafkaConsumer
from kafka.structs import TopicPartition
import datetime
consumer = KafkaConsumer(
    # 'logcoll-v2',
    # auto_offset_reset='earliest',
    bootstrap_servers='192.168.13.46:9092',
    group_id="pythontest"

)

tp = "RespGoodsInfoTemp"
offs = 319065439
topcum = 24
L = []
for i in range(topcum):
    L.append(TopicPartition(topic=tp, partition=i))
consumer.assign(L)



for i in range(24):
    consumer.seek(TopicPartition(topic=tp, partition=i), offs)

for message in consumer:
    print("%s:%d:%d: key=%s value=%s" % (message.topic, message.partition,
                                         message.offset, message.key,
                                         message.value))
```