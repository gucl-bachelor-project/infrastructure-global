variable "aws_access_key" {
  type        = string
  description = "Access key of AWS credentials"
}

variable "aws_secret_key" {
  type        = string
  description = "Secret key of AWS credentials"
}

variable "do_api_token" {
  type        = string
  description = "API token for DigitalOcean to manage resources"
}

variable "do_region" {
  default     = "fra1"
  description = "Region to deploy DigitalOcean resources in"
}

variable "do_spaces_region" {
  default     = "ams3"
  description = "Region to deploy DigitalOcean Spaces in"
}

variable "do_spaces_access_key_id" {
  type        = string
  description = "Access key to project's DigitalOcean Spaces bucket"
}

variable "do_spaces_secret_access_key" {
  type        = string
  description = "Secret key to project's DigitalOcean Spaces bucket"
}

variable "pvt_key" {
  type        = string
  description = "Path to private key on machine executing Terraform. The public key must be registered on DigitalOcean. See: ssh-keys.tf"
}