aws configure set aws_access_key_id "dummy" --profile test-profile
aws configure set aws_secret_access_key "dummy" --profile test-profile
aws configure set region "eu-central-1" --profile test-profile
aws configure set output "table" --profile test-profile

aws sqs list-queues  --endpoint-url http://localhost:4566

aws sns list-topics  --endpoint-url http://localhost:4566

aws s3 ls --endpoint-url http://localhost:4566

aws --endpoint-url=http://localhost:4566 sns list-subscriptions


aws --endpoint-url=http://localhost:4566 sns subscribe --topic-arn arn:aws:sns:eu-central-1:000000000000:local-topic --protocol sqs --notification-endpoint arn:aws:sqs:eu-central-1:000000000000:dev-mao-order-events

aws --endpoint-url=http://localhost:4566 sns subscribe --topic-arn arn:aws:sns:eu-central-1:000000000000:local-topic --protocol sqs --notification-endpoint arn:aws:sqs:eu-central-1:000000000000:dev-mao-accounting-events

aws --endpoint-url=http://localhost:4566 sns subscribe --topic-arn arn:aws:sns:eu-central-1:000000000000:local-topic --protocol sqs --notification-endpoint arn:aws:sqs:eu-central-1:000000000000:dev-mao-shipping-events

aws --endpoint-url=http://localhost:4566 sns subscribe --topic-arn arn:aws:sns:eu-central-1:000000000000:local-topic --protocol sqs --notification-endpoint arn:aws:sqs:eu-central-1:000000000000:mao-marketing-events

aws --endpoint-url=http://localhost:4566 sns subscribe --topic-arn arn:aws:sns:eu-central-1:000000000000:local-topic --protocol sqs --notification-endpoint arn:aws:sqs:eu-central-1:000000000000:mao-pricing-policy-events

aws --endpoint-url=http://localhost:4566 sns list-subscriptions
