# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OUTPUT OF MODULE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# DOCKER REGISTRY
# ------------------------------------------------------------------------------
output "ecr_repositories" {
  value       = aws_ecr_repository.ecr_repositories
  description = "All ECR repositories"
}

output "ecr_registry_base_url" {
  value       = local.ecr_registry_base_url
  description = "Base URL of ECR registry (registry URL without repository IDs). Example: 468374654130.dkr.ecr.eu-central-1.amazonaws.com'"
}

output "ecr_region" {
  value       = data.aws_region.current
  description = "AWS region where ECR registry is hosted"
}

# ------------------------------------------------------------------------------
# PROJECT BUCKET ON DIGITALOCEAN SPACES
# ------------------------------------------------------------------------------
output "project_bucket_name" {
  value       = digitalocean_spaces_bucket.project_bucket.name
  description = "The name of the project's DigitalOcean Spaces bucket"
}

output "project_bucket_region" {
  value       = digitalocean_spaces_bucket.project_bucket.region
  description = "The slug of the region where the project's DigitalOcean Spaces bucket is stored. Example: 'ams3'"
}

# ------------------------------------------------------------------------------
# SSH KEYS
# ------------------------------------------------------------------------------
output "registered_ssh_keys_names" {
  value       = [for ssh_key in digitalocean_ssh_key.vm_ssh_keys : ssh_key.name]
  description = "List of names for registered SSH keys (in DigitalOcean) that should have SSH access to the deployed VMs"
}

# ------------------------------------------------------------------------------
# DATABASE
# ------------------------------------------------------------------------------
output "db_clusters" {
  value = {
    production  = module.production_db
    staging     = module.staging_db
    development = module.development_db
  }
  description = "DigitalOcean DB clusters for all environments"
}

# ------------------------------------------------------------------------------
# DROPLET TAGS
# ------------------------------------------------------------------------------
output "logging_vm_allowed_droplet_tag_name" {
  value       = digitalocean_tag.logging_vm_access_allowed_droplet_tag.name
  description = "Name of tag that can be assigned to DigitalOcean Droplets (i.e. VMs) that should have access to the logging VM"
}

output "db_allowed_droplet_tags" {
  value = {
    production  = digitalocean_tag.db_allowed_droplet_tags["production"].name
    staging     = digitalocean_tag.db_allowed_droplet_tags["staging"].name
    development = digitalocean_tag.db_allowed_droplet_tags["development"].name
  }
  description = "Name of tags that can be assigned to DigitalOcean Droplets (i.e. VMs) that should have access to environment-specific DB cluster"
}

# ------------------------------------------------------------------------------
# IP ADDRESSES
# ------------------------------------------------------------------------------
output "ips" {
  value = {
    prod_website   = digitalocean_floating_ip.prod_website.ip_address
    logging_server = digitalocean_floating_ip.logging_vm.ip_address
  }
  description = "IPv4 addresses for application"
}
