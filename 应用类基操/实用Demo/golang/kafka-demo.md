
## producer 示例（partition 负载均衡）

```
package main

import (
	"context"
	"fmt"
	"github.com/segmentio/kafka-go"
	"strconv"
)

func main() {
	conn := kafka.Writer{
		Addr:     kafka.TCP("192.168.14.82:9092"),
		Topic:    "yxdtest",
		Balancer: &kafka.RoundRobin{},
	}
	c := 0
	for {
		if err := conn.WriteMessages(context.Background(),
			kafka.Message{
				Value: []byte(strconv.Itoa(c)),
			},
		); err != nil {
			fmt.Println(err)
		}
		c += 1
		fmt.Println(c)
	}
}
```


## producer示例

```
package main

import (
	"context"
	"fmt"
	"github.com/segmentio/kafka-go"
	"log"
	"time"
)

func main() {
	// to produce message
	topic := "my-topic"
	partition := 0
	conn, err := kafka.DialLeader(context.Background(), "tcp", "192.168.14.81:9092", topic, partition)
	if err != nil {
		log.Fatal("failed to dial leader:", err)
	}

	conn.SetWriteDeadline(time.Now().Add(10 * time.Second))
	c := 0
	for {
		_, err := conn.WriteMessages(
		kafka.Message{Value: []byte("sdfhsjdhfjsd")},
		)
		if err != nil {
			log.Fatal(err)
		}
		c = c + 1
		fmt.Println(c)
		break
	}


}
```


## consumer示例

```
package main

import (
	"context"
	"fmt"
	"github.com/segmentio/kafka-go"
	"log"
)

func main()  {
	r := kafka.NewReader(kafka.ReaderConfig{
		Brokers:   []string{"192.168.16.3:9092"},
		GroupID:   "stream-load",
		Topic:     "OrderPullTikTokShopProd",
		MinBytes:  10e3, // 10KB
		MaxBytes:  10e6, // 10MB
	})
	ctx := context.Background()
	for {
		m, err := r.FetchMessage(ctx)
		if err != nil {
			break
		}
		fmt.Printf("message at topic/partition/offset %v/%v/%v: %s = %s\n", m.Topic, m.Partition, m.Offset, string(m.Key), string(m.Value))

		//if find := strings.Contains(string(m.Value), "HI"); find {
		//	fmt.Println(string(m.Value))
		//}
		if err := r.CommitMessages(ctx, m); err != nil {
			log.Fatal("failed to commit messages:", err)
		}
	}
	if err := r.Close(); err != nil {
		log.Fatal("failed to close reader:", err)
	}
}
```