# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESOURCES TO PERSIST APPLICATION DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# DEPLOY DIGITALOCEAN BLOCK STORAGE FOR PRODUCTION LOG DATA
# ------------------------------------------------------------------------------
resource "digitalocean_volume" "prod_log_block_storage" {
  region                  = var.do_region
  name                    = "prod-log-data"
  initial_filesystem_type = "xfs" # Best for performance in MongoDB
  description             = "Storage for logs in production environment"
  size                    = 1 # GB

  lifecycle {
    prevent_destroy = true
  }
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY S3 BUCKET FOR APPLICATION DOCKER COMPOSE FILES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "aws_s3_bucket" "app_docker_composes_bucket" {
  bucket = "gkc-bproject-app-docker-composes"

  # Enables full revision history of the Docker Compose files
  versioning {
    enabled = true
  }
}

output "app_docker_composes_bucket_id" {
  value       = aws_s3_bucket.app_docker_composes_bucket.id
  description = "ID of S3 bucket"
}
