variable "do_api_token" {
  type        = string
  description = "API token for DigitalOcean to manage resources"
}

variable "do_region" {
  default     = "fra1"
  description = "Region to deploy DigitalOcean resources in"
}
