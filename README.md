# infrastructure-global

TODO:
- Terraform: 0.12.28
- AWS region: eu-central-1
- Required IAM user:
  - AmazonS3FullAccess
  - AmazonRoute53FullAccess
  - AmazonEC2ContainerRegistryFullAccess
  - AmazonDynamoDBFullAccess
  - IAMFullAccess
- Pipeline:
  - Env vars: AWS_ACCESS_KEY, AWS_SECRET_KEY, DO_API_TOKEN, GH_AUTH_TOKEN
