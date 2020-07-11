# ------------------------------------------------------------------------------
# REFERENCE REMOTE BACKEND WHERE THE TERRAFORM STATE IS STORED AND LOADED
# ------------------------------------------------------------------------------
terraform {
  backend "s3" {
    encrypt        = true
    key            = "global/terraform.tfstate"
    region         = "eu-central-1"
    bucket         = "gkc-bproject-terraform-backend"
    dynamodb_table = "gkc-bproject-terraform-lock"
  }
}

# ------------------------------------------------------------------------------
# SET UP DIGITALOCEAN PROVIDER
# ------------------------------------------------------------------------------
provider "digitalocean" {
  token = var.do_api_token
}

# ------------------------------------------------------------------------------
# SET UP AWS PROVIDER
# ------------------------------------------------------------------------------
provider "aws" {
  region = "eu-central-1"
}

# ------------------------------------------------------------------------------
# REFERENCE AWS REGION WHERE AWS RESOURCES MUST BE DEPLOYED IN
# ------------------------------------------------------------------------------
data "aws_region" "current" {}

# ------------------------------------------------------------------------------
# DEPLOY REMOTE TERRAFORM STATE BACKEND
# ------------------------------------------------------------------------------
module "s3_backend" {
  source = "./s3-backend"

  # NOTE:
  # - Bucket name has to globally unique amongst all AWS users
  # - Value must match value of 'bucket' in 'backend' block
  backend_bucket_name = "gkc-bproject-terraform-backend"

  # NOTE:
  # Value must match value of 'dynamodb' in 'backend' block
  backend_lock_table_name = "gkc-bproject-terraform-lock"
}
