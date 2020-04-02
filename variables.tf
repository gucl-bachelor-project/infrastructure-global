variable "do_api_token" {
  type        = string
  description = "API token for DigitalOcean to manage resources"
}

variable "do_region" {
  default     = "fra1"
  description = "Region to place DigitalOcean resources in"
}

variable "logging_app_os_image_id" {
  type        = string
  description = "ID of OS image in DigitalOcean to boot logging app VM/Droplet from"
}

variable "vm_user_aws_access_key_id" {
  type        = string
  description = "AWS access key ID of user to use on application VM"
}

variable "vm_user_aws_secret_access_key" {
  type        = string
  description = "AWS access key secret of user to use on application VM"
}
