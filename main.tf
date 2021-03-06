# ------------------------------------------------------------------------------
# REFERENCE REMOTE BACKEND WHERE THE TERRAFORM STATE IS STORED AND LOADED
# ------------------------------------------------------------------------------
terraform {
  backend "s3" {
    encrypt        = true
    key            = "global/terraform.tfstate"
    region         = "eu-central-1"
    bucket         = "gkc-bproject-terraform-backend" # See https://github.com/gucl-bachelor-project/infrastructure-remote-state
    dynamodb_table = "gkc-bproject-terraform-lock"    # See: https://github.com/gucl-bachelor-project/infrastructure-remote-state
  }
}

# ------------------------------------------------------------------------------
# SET UP DIGITALOCEAN PROVIDER
# ------------------------------------------------------------------------------
provider "digitalocean" {
  token = var.do_api_token

  spaces_access_id  = var.do_spaces_access_key_id
  spaces_secret_key = var.do_spaces_secret_access_key
}

# ------------------------------------------------------------------------------
# SET UP AWS PROVIDER
# ------------------------------------------------------------------------------
provider "aws" {
  region     = "eu-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# ------------------------------------------------------------------------------
# REFERENCE AWS REGION WHERE AWS RESOURCES MUST BE DEPLOYED IN
# ------------------------------------------------------------------------------
data "aws_region" "current" {}
