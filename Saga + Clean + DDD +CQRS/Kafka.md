if consumers go down, the events stay in the queue of Kafka

Primary mote of Kafka is the ability to replay events

Kafka can be easily scaled horizontally

##### kafka cluster
the machines running kafka
each individual machine is known as broker

![[Pasted image 20250514082520.png]]

##### topic
logical channel to which producers send messages and from which consumers read messages

multiple producers can be producing to the same or different topics

a redis pub sub is not load balanced every subscriber gets all the messages

but kafka can be different

if multiple consumers consume from the same topic they can be put into a consumer group
and within the consumer group the events can be load balanced, that is in a round robin fashion messages can be load balanced over the consumers in the consumer group.

**if we want every consumer to get all the messages we can have consumer groups with single consumers**
**and have multiple consumer groups subscribe to the same topic**
##### Offsets
consumers keep track of their position in the topic by maintaining offsets, which is basically he position of the last consumed message.
kafka can manage offsets automatically or allow consumers to manage them manually

when a consumer reads a message the offset for the whole consumer group increased

offsets are tracked per consumer group , per topic partition

- **Per-Partition Granularity**: Each partition has its own independent offset for each consumer group.
- **No Global Group Offset**: There isn't a single "group offset" that increases when any consumer reads a message.
- **Consumer Group Coordination**: Offsets are managed collectively for the group, but tracked individually per partition.
If a consumer fails, when it (or another consumer taking over its partitions) restarts, it needs to know exactly where to resume for each partition. With per-partition offsets:

- Only affected partitions need to be reprocessed from their last committed offset
- Unaffected partitions continue without disruption
##### partitions
are subdivisions of a kafka topic
each partition is an ordered, immutable sequence of messages that is appended to by the producers, partitions allow kafka to scale horizontally
allows parallel processing of messages
partitions are distributed across brokers
![[Pasted image 20240718102454.png]]
by default a topic will only have a single partition. 
the instances in the consumer groups can be assigned to specific partitions
its only useful to have more than one consumer when we have more than one partitions
while creating topics we can tell how many partitions we need using the --partitions flag

if a Kafka topic has 3 partitions, **each partition does not have the same data**. Each message produced to the topic is stored in exactly one of the partitions, not all of them.

- **Partitioning** is used for scalability and parallelism. When a producer sends a message to a topic, Kafka decides which partition to store the message in, based on the partitioning strategy

each partition can have replicas on other brokers for fault tolerance, but these are copies of the same partition, not copies across different partitions

So, **the data in each partition is different**. Only if your producer sends the same message multiple times to different partitions (which is not typical or automatic), would the partitions contain the same data.

### Zookeeper
Orchestrator of the brokers
not required after kafka 2.8
#### schema registry
we can share and enforce schema when producing and consuming from kafka, with the schema stored in kafka itself
in the first call, the producers first sends the schema to the schema registry and get an id
the producers uses this schema id, and serializes the data with this schema, either AVRO or Protobuf
then the data with the schema id is sent to the kafka broker
consumer first reads the id and gets the schema details from the schema registry , consumes the raw data and then uses the schema details to deserialize the data
producers and consumers maintain a local cache as well for the schema

![[Pasted image 20250514091823.png]]
#### init
> docker run -p 9092:9092 apache/kafka:3.7.1
> docker exec -it contianer_id /bin/bash
> cd /opt/kafka/bin

to create a topic via shell we need the kafka-topics shell script
and scripts for producing and consuming

> ./kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092

> ./kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
> ./kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092

these three scripts to create topic produce and consume will be inside the container at /opt/kafka/bin
we can run the above commands in opt/kafka/bin

#### node.js client
> npm i kafkajs

```ts
import { Kafka } from 'kafkajs';
  
const kafka = new Kafka({
  clientId: 'publisher',
  brokers: ['localhost:9092'],
});
  
const producer = kafka.producer();
const consumer = kafka.consumer({ groupId: 'test-group' });
  
const run = async () => {
  await producer.connect();
  await producer.send({
    topic: 'test-topic',
    messages: [{ value: 'hello' }],
  });
  
  await consumer.connect();
  await consumer.subscribe({ topic: 'test-topic', fromBeginning: true });
  
  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      console.log({
        partition,
        offset: message.offset,
        value: message.value?.toString(),
      });
    },
  });
};
  
run();
```

if we break this logic into two different files, one for producer and one for consumer
producer.ts
```ts
import { Kafka } from 'kafkajs';
  
const kafka = new Kafka({
  clientId: 'publisher',
  brokers: ['localhost:9092'],
});
  
const producer = kafka.producer();
  
const run = async () => {
  await producer.connect();
  await producer.send({
    topic: 'test-topic',
    messages: [{ value: 'hello' }],
  });
};
  
run();
```

consumer.ts
```ts
import { Kafka } from 'kafkajs';
  
const kafka = new Kafka({
  clientId: 'publisher',
  brokers: ['localhost:9092'],
});
  

const consumer = kafka.consumer({ groupId: 'test-group' });
  
const run = async () => {
  await consumer.connect();
  await consumer.subscribe({ topic: 'test-topic', fromBeginning: true });
  
  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      console.log({
        partition,
        offset: message.offset,
        value: message.value?.toString(),
      });
    },
  });
};
  
run();
```

in this case
only the latest events will be consumed

and if i start multiple consumers in different processes only one will get the produced message
and next events will go to the second consumer
why? becuase we gave a groupid to the consumers so they are now part of the same consumer group and are load balanced
we can add Math.random() to the group Id if we want all the consumers to get all the events

when we pull something from a queue we should send an acknowledgment to tell that the processing has been done, because if our processor instance dies while in the middle of processing the message it received form kafka. kafka will think that it toh sent the message to that worker, so that must mean the work was done, but work in-fact would not have been done.
so this acknowledgment that the work has been done should be a manual step that we must add to the processor function. 
correct consumer.ts
```ts
import { Kafka } from 'kafkajs';  
const TOPIC = 'workflow-events';  
const kafka = new Kafka({  
  clientId: 'outbox-processor',  
  brokers: ['localhost:9092'],  
});  
  
async function worker() {  
  const consumer = kafka.consumer({ groupId: 'worker' });  
  await consumer.connect();  
  await consumer.subscribe({  
    topic: TOPIC,  
    fromBeginning: true,  
  });  
  await consumer.run({  
    autoCommit: false,  
    eachMessage: async ({ topic, partition, message }) => {  
      console.log({  
        partition,  
        val: message.value?.toString(),  
        offset: message.offset,  
        topic,  
      });  
      await consumer.commitOffsets([  
        {  
          topic,  
          partition,  
          offset: message.offset,  
        },  
      ]);  
    },  
  });  
}  
worker();
```
kafka has this built in by using the **==autoCommit:false==** in the run function parameter
and the ***consumer.commitOffsets()*** function
##### whats the use consumer groups?
- fault tolerance 
- load balancing
- parallel processing
a consumer group doesnt read a piece of data twice, so if i have 5 order api containers and all have the same group id, only once will the data be read and order will not be processed multiple times
kafka manages which consumer will be assigned to which partition
when we increase the number of consumer kafka does some rebalancing between the consumers
#### if the number of consumers in a consumer group is more than the number of partitions then the consumers will remain idle
the only use case for extra consumers is fault tolerance, in case a consumer goes down another consumer can start consuming


 **if you have a consumer group B with 5 consumers and you want all consumers to be actively consuming from topic A, then topic A should have at least 5 partitions**.

we can see which consumer is assigned to which partition with
> ./kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group my-app3

### partitioning strategy
when producing messages we can assign a key that uniquely identifies the event
kafka hashes the key and uses the hash to determine which partition it will go to
all messages with the same key go to the same partition

why would we want that?
lets say a single user has too many notifications, using this strategy they only choke one partition
or the consumption of a type of submission is more time consuming than others

this also protects against DDOS attacks, because the attacker wont be able to choke all my partitions

another use case is, that if we want the events of one user to be handled sequentially only, then we can use a key for the user to send all the messages to the same partition and then they will be handled sequentially

producer.ts
```ts
import { Kafka } from 'kafkajs';
  
const kafka = new Kafka({
  clientId: 'publisher',
  brokers: ['localhost:9092'],
});
  
const producer = kafka.producer();
  
const run = async () => {
  await producer.connect();
  await producer.send({
    topic: 'test-topic',
    messages: [{ value: 'hello', key:"user1" }],
  });
};
  
run();
```

the key in the messages list is the extra thing we need to add to facilitate this behaviour