# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY AMAZON ECRs USED AS CONTAINER IMAGE REPOSITORIES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

locals {
  business_logic_repos = ["bl-main-app", "bl-support-app"]
  logging_repos        = ["logging-app"]
  db_repos             = ["db-access-app", "db-access-admin-app"]
  web_server_repos     = ["nginx"]
}

# ------------------------------------------------------------------------------
# CREATE ALL ECR REPOSITORIES DEFINED IN THE GROUPS IN 'locals'
# ------------------------------------------------------------------------------
resource "aws_ecr_repository" "ecr_repositories" {
  for_each = toset(concat(local.business_logic_repos, local.logging_repos, local.db_repos, local.web_server_repos))

  name                 = "bproject-${each.key}"
  image_tag_mutability = "MUTABLE" # Allow override of tags
}

output "image_registries" {
  value       = aws_ecr_repository.ecr_repositories
  description = "All ECR repositories"
}

output "ecr_base_url" {
  value       = replace(aws_ecr_repository.ecr_repositories["bl-main-app"].repository_url, "/${aws_ecr_repository.ecr_repositories["bl-main-app"].name}", "")
  description = "Base URL of ECR repositories (registry URL without registry ID). Example: '468374654130.dkr.ecr.eu-central-1.amazonaws.com'"
}

data "aws_region" "current" {}

output "ecr_region" {
  value       = data.aws_region.current
  description = "AWS region of ECR service"
}
