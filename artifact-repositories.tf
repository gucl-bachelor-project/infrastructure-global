# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ARTIFACT REPOSITORIES FOR APPLICATION.
# - Deploy Amazon ECR repositories used as a Docker image registry.
# - Deploy Amazon S3 bucket for Docker Compose files used in different subsystems of the application.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

locals {
  # Base URL of ECR registry (registry URL without repository IDs).
  # Example: 468374654130.dkr.ecr.eu-central-1.amazonaws.com/bproject-bl-main-app ->
  # 468374654130.dkr.ecr.eu-central-1.amazonaws.com
  ecr_registry_base_url = replace(
    aws_ecr_repository.ecr_repositories["bl-main-app"].repository_url,
    "/${aws_ecr_repository.ecr_repositories["bl-main-app"].name}",
    ""
  )

  # Names of ECR repositories defined in categories
  business_logic_subsystem_repos = [
    "bl-main-app",
    "bl-support-app"
  ]
  logging_subsystem_repos = [
    "logging-app"
  ]
  persistence_subsystem_repos = [
    "db-administration-app",
    "db-admin-administration-app"
  ]
  web_server_repos = [
    "nginx"
  ]
}

# ------------------------------------------------------------------------------
# DEPLOY ALL ECR REPOSITORIES DEFINED IN THE GROUPS IN 'locals'
# ------------------------------------------------------------------------------
resource "aws_ecr_repository" "ecr_repositories" {
  for_each = toset(
    concat(
      local.business_logic_subsystem_repos,
      local.logging_subsystem_repos,
      local.persistence_subsystem_repos,
      local.web_server_repos
    )
  )

  name                 = "bproject-${each.key}"
  image_tag_mutability = "MUTABLE" # Allow override of Docker tags
}

# ------------------------------------------------------------------------------
# DEPLOY AMAZON S3 BUCKET FOR DOCKER COMPOSE FILES AND CONFIGURE IT TO
# BLOCK PUBLIC ACCESS
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "app_docker_composes_bucket" {
  bucket = "bproject-app-docker-composes"

  # Enables full revision history of the Docker Compose files
  versioning {
    enabled = true
  }
  #tfsec:ignore:AWS002
  #tfsec:ignore:AWS017
}

resource "aws_s3_bucket_public_access_block" "app_docker_compose_files_bucket_block" {
  bucket = aws_s3_bucket.app_docker_composes_bucket.id

  block_public_policy     = true
  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
