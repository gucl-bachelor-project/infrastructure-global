terraform {
  required_version = ">= 0.12"

  required_providers {
    aws          = "~> 2.69.0"
    digitalocean = "~> 1.20.0"
    template     = "~> 2.1.2"
  }
}
