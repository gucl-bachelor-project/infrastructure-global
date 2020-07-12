# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OUTPUT OF MODULE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# ARTIFACT REPOSITORIES
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

output "app_docker_compose_files_bucket_id" {
  value       = aws_s3_bucket.app_docker_composes_bucket.id
  description = "ID of S3 bucket"
}

# ------------------------------------------------------------------------------
# CREDENTIALS
# ------------------------------------------------------------------------------
output "iam_app_vm_user_credentials" {
  value       = aws_iam_access_key.app_vm_user_access_key
  description = "Credentials for IAM user to be used to access AWS services on application VMs"
  sensitive   = true # Value not shown in CLI output
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
