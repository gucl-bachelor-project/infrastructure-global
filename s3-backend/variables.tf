variable "backend_bucket_name" {
  type        = string
  description = "Name of S3 bucket to use as backend"
}

variable "backend_lock_table_name" {
  type        = string
  description = "Name of DynamoDB table to use as locking mechanism for backend"
}
