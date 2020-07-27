# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DOCKER REGISTRY FOR APPLICATION.
# Deploy Amazon ECR repositories used as a Docker image registry.
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

  image_scanning_configuration {
    scan_on_push = true
  }
}
