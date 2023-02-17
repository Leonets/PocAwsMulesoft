# Gucci Playground (experiment with Aws, Kotlin & Local Development)

## Coding core

Design and implement a system that is continuously pulling all the submitted orders 
to the network and detects different order's type for then submitting to the appropriate system.

- When an order is detected, store the information regarding the order, the total amount and the destination, and then:
  - let a subsystem decide if the price needs to be changed
  - distribute the order to the subsequent systems (order, shipping and accounting) in pairs with interacting with external system (API)
- [OPT] Given a list of countries, just filter orders involving those countries.
- [OPT] Create a dashboard showing grouped orders by country and total amount
- Data can be stored in memory 
- Orders only need to be tracked since the application is started

Please detail a solution using Mulesoft and AWS (SQS, SNS, S3)

Please provide useful examples for evaluating the following:

- fault tolerance to sqs crash
- fault tolerance to sns crash
- queue operations affected by visibility timeout

# Proposed solution

The solution developed makes use of the following

## Notification Layer

An SNS service listens on the topic and republish on three different queue (Shipping; Accounting; Order)

[Aws Simple Notification Service](support/sns-architecture.png)

## Queue Layer

An SQS service manages 5 different queues (Shipping; Accounting; Order, Marketing and Pricing_Policy)

[Aws Simple Queue Service](support/sqs-architecture.png)

## Data Layer

An S3 service offers the storage service

## Orders API

The following API/Topic/Queue have been built that contains the following endpoints:

| Endpoint          | Medhod | Description                                                                          | Availability |
| ----------------- | ------ | ------------------------------------------------------------------------------------ | ------------ |
| /api/orders       | POST   | Receives orders in json format and delivers in queue 'Marketing' and topic 'Orders'  | Done         |
|                   |        | (it also save the payload in the S3 GucciBucket)                                     |              |
| /api/dashboard    | GET    | Returns orders summary by showing country, total orders, total amount (data from S3) | Done         |
| /api/shipping     | GET    | Returns order shipping details (data from S3)                                        | Done         |

## Integration layer

This layer manages the following operations:

- listens on a specific queue (Marketing) and then decides if the item price need to be changed 
  and if then sends a message to a specific queue (Pricing_Policy)
- listens over the three queues (Accounting, Shipping, Orders) for then forwarding the request to an external system (HTTP)


## Draw.io diagram

[System Diagram](support/guccidemomulo.jpg)


## AWS 

Having AWS configured in this way:

aws configure
AWS Access Key ID [****************dKey]: mule

AWS Secret Access Key [****************cret]: mule

Default region name [eu-central-1]: 

Default output format [json]: json

## ElasticMQ as a cloud service emulator (first possible alternative, node process speed up the CPU on Ubuntu 20.04)

**Execute the ElasticMQ stack in this way**:

AnypointStudioWorkspace/guccidemo/support/elasticmq$ **docker compose up**

## Localstack as a cloud service emulator (second possible alternative)

**Execute the LocalStack in this way**:

AnypointStudioWorkspace/guccidemo/support/localstack$ **docker compose up**

### Prepare the environment over the LocalStack (Queues)

Create the Queue with Aws cli:

aws --endpoint-url=[http://localhost:4566](http://localhost:4566) sqs create-queue --queue-name mao-marketing-events

aws --endpoint-url=[http://localhost:4566](http://localhost:4566) sqs create-queue --queue-name dev-mao-order-events

{
 "QueueUrl": "http://localhost:4566/000000000000/dev-mao-order-events" }

aws --endpoint-url=[http://localhost:4566](http://localhost:4566) sqs create-queue --queue-name mao-pricing-policy-events

aws --endpoint-url=[http://localhost:4566](http://localhost:4566) sqs create-queue --queue-name dev-mao-accounting-events

aws --endpoint-url=[http://localhost:4566](http://localhost:4566) sqs create-queue --queue-name dev-mao-shipping-events

the ARN of this queue is "arn:aws:sqs:eu-central-1:000000000000:dev-mao-shipping-events"

### Prepare the environment over the LocalStack (Topics)

Create the Topic with Aws cli:

aws sns create-topic --name local-topic --endpoint-url [http://localhost:4566](http://localhost:4566) {
 "TopicArn": "TopicArn": "arn:aws:sns:eu-central-1:000000000000:local-topic"
}

### Prepare the environment (Anypoint) (Configure the AWS connectors)

Configure in this way

[SQS Config](support/sqs-config.png)

[SQS Advanced](support/sqs-advanced.png)

[SNS Config](support/sns-config.png)

[SNS Advanced](support/sns-advanced.png)

[S3 Config](support/s3-configuration.png)

[S3 Advanced](support/s3-advanced.png)

### Localstack Tutorial

[LocalStack and MuleSoft](https://www.linkedin.com/pulse/localstack-mulesoft-amir-khan/?trk=pulse-article_more-articles_related-content-card)

[https://docs.localstack.cloud/](https://docs.localstack.cloud/)

### Tools developed for a quick provision (LocalStack)

There were developed two script for preparing and checking the Localstack infrastructure

- **support/localstack/prepare.sh** (prepare the queues, the topic and its subscriptions)

```
{
    "QueueUrl": "http://localhost:4566/000000000000/mao-marketing-events"
}
{
    "QueueUrl": "http://localhost:4566/000000000000/dev-mao-order-events"
}
{
    "QueueUrl": "http://localhost:4566/000000000000/mao-pricing-policy-events"
}
{
    "QueueUrl": "http://localhost:4566/000000000000/dev-mao-accounting-events"
}
{
    "QueueUrl": "http://localhost:4566/000000000000/dev-mao-shipping-events"
}
{
    "TopicArn": "arn:aws:sns:eu-central-1:000000000000:local-topic"
}
```

- **support/localstack/check.sh** (checks if anything has been correctly executed)

```
{
    "QueueUrls": [
        "http://localhost:4566/000000000000/mao-marketing-events",
        "http://localhost:4566/000000000000/dev-mao-order-events",
        "http://localhost:4566/000000000000/mao-pricing-policy-events",
        "http://localhost:4566/000000000000/dev-mao-accounting-events",
        "http://localhost:4566/000000000000/dev-mao-shipping-events"
    ]
}
{
    "Topics": [
        {
            "TopicArn": "arn:aws:sns:eu-central-1:000000000000:local-topic"
        }
    ]
}
{
    "Subscriptions": []
}
{
    "SubscriptionArn": "arn:aws:sns:eu-central-1:000000000000:local-topic:030edded-7bbb-4c2b-ba08-3b5270c94b7c"
}
{
    "SubscriptionArn": "arn:aws:sns:eu-central-1:000000000000:local-topic:3d6f4c54-3619-4f1f-a8db-c988218ed7c2"
}
{
    "SubscriptionArn": "arn:aws:sns:eu-central-1:000000000000:local-topic:8a2a0031-44ec-4349-98f4-e894a2a3b57b"
}
{
    "SubscriptionArn": "arn:aws:sns:eu-central-1:000000000000:local-topic:c4ac80b5-8b7d-42e9-9c1c-7e7b23db2917"
}
{
    "SubscriptionArn": "arn:aws:sns:eu-central-1:000000000000:local-topic:4750b2b4-f785-40cf-99e2-d134826650cf"
}
{
    "Subscriptions": [
        {
            "SubscriptionArn": "arn:aws:sns:eu-central-1:000000000000:local-topic:030edded-7bbb-4c2b-ba08-3b5270c94b7c",
            "Owner": "000000000000",
            "Protocol": "sqs",
            "Endpoint": "arn:aws:sqs:eu-central-1:000000000000:dev-mao-order-events",
            "TopicArn": "arn:aws:sns:eu-central-1:000000000000:local-topic"
        },
        {
            "SubscriptionArn": "arn:aws:sns:eu-central-1:000000000000:local-topic:3d6f4c54-3619-4f1f-a8db-c988218ed7c2",
            "Owner": "000000000000",
            "Protocol": "sqs",
            "Endpoint": "arn:aws:sqs:eu-central-1:000000000000:dev-mao-accounting-events",
            "TopicArn": "arn:aws:sns:eu-central-1:000000000000:local-topic"
        },
        {
            "SubscriptionArn": "arn:aws:sns:eu-central-1:000000000000:local-topic:8a2a0031-44ec-4349-98f4-e894a2a3b57b",
            "Owner": "000000000000",
            "Protocol": "sqs",
            "Endpoint": "arn:aws:sqs:eu-central-1:000000000000:dev-mao-shipping-events",
            "TopicArn": "arn:aws:sns:eu-central-1:000000000000:local-topic"
        },
        {
            "SubscriptionArn": "arn:aws:sns:eu-central-1:000000000000:local-topic:c4ac80b5-8b7d-42e9-9c1c-7e7b23db2917",
            "Owner": "000000000000",
            "Protocol": "sqs",
            "Endpoint": "arn:aws:sqs:eu-central-1:000000000000:mao-marketing-events",
            "TopicArn": "arn:aws:sns:eu-central-1:000000000000:local-topic"
        },
        {
            "SubscriptionArn": "arn:aws:sns:eu-central-1:000000000000:local-topic:4750b2b4-f785-40cf-99e2-d134826650cf",
            "Owner": "000000000000",
            "Protocol": "sqs",
            "Endpoint": "arn:aws:sqs:eu-central-1:000000000000:mao-pricing-policy-events",
            "TopicArn": "arn:aws:sns:eu-central-1:000000000000:local-topic"
        }
    ]
}
```

## Libraries version used 

```
**********************************************************************
* Started app 'guccidemo'                                            *
* Application plugins:                                               *
*  - Amazon S3 : 6.1.0                                               *
*  - Amazon SNS : 4.7.3                                              *
*  - Amazon SQS : 5.11.7                                             *
*  - Sockets : 1.2.3                                                 *
*  - Tracing : 1.0.0                                                 *
*  - Validation : 2.0.2                                              *
*  - HTTP : 1.7.3                                                    *
*  - APIKit : 1.8.1                                                  *
**********************************************************************
```

## Payload that represents Orders

```
{
“Orders”: 
    "Order":{
        "item": "id1",
        "size": "M"
        "price": 400,
        "color": "blue",
        "address": "via roma 1",
        "cap": "50144",
        "destinationCountry": "IT"
    },
    "Order":{
        "item": "id2",
        "size": "L"
        "price": 800,
        "color": "red",
        "address": "via milano 1",
        "cap": "50100",
        "destinationCountry": "IT"
    },
    "Order":{
        "item": "id3",
        "size": "L"
        "price": 3000,
        "color": "black",
        "address": "unknown 898",
        "cap": "19090",
        "destinationCountry": "JP"
    }
}
```

## TODO

To list messages from a queue with Localstack

aws sqs get-queue-attributes --attribute-names=All --endpoint-url http://localhost:4566 --queue-url=http://localhost:4566/000000000000/dev-mao-accounting-events


