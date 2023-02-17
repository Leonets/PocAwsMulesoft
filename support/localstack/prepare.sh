aws --endpoint-url=http://localhost:4566  sqs create-queue --queue-name mao-marketing-events

aws --endpoint-url=http://localhost:4566  sqs create-queue --queue-name dev-mao-order-events

aws --endpoint-url=http://localhost:4566  sqs create-queue --queue-name mao-pricing-policy-events

aws --endpoint-url=http://localhost:4566  sqs create-queue --queue-name dev-mao-accounting-events

aws --endpoint-url=http://localhost:4566  sqs create-queue --queue-name dev-mao-shipping-events



aws sns create-topic --name local-topic --endpoint-url http://localhost:4566
