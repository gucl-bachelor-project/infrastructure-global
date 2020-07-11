# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# AWS IDENTITY AND ACCESS MANAGEMENT (IAM) CONFIGURATION TO MANAGE ACCESS TO DEPLOYED RESOURCES ON AWS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# CREATE IAM USER FOR VMS THAT MUST ACCESS SERVICES ON AWS (E.G. TO FETCH
# ARTIFACTS)
# ------------------------------------------------------------------------------
resource "aws_iam_user" "app_vm_user" {
  name = "BprojectAppVMUser"
}

# ------------------------------------------------------------------------------
# CREATE CREDENTIALS FOR VM IAM USER
# ------------------------------------------------------------------------------
resource "aws_iam_access_key" "app_vm_user_access_key" {
  user = aws_iam_user.app_vm_user.name
}

# ------------------------------------------------------------------------------
# COMPOSE IAM POLICY THAT ALLOWS ACCESS FOR ARTIFACT REPOSITORIES (I.E. ECR
# REPOSITORIES AND S3 BUCKET WITH DOCKER COMPOSE FILES) AND ATTACH THIS
# POLICY TO VM IAM USER
# ------------------------------------------------------------------------------
resource "aws_iam_user_policy" "app_vm_user_policy" {
  name   = "BprojectAppVMUserPolicy"
  user   = aws_iam_user.app_vm_user.name
  policy = data.aws_iam_policy_document.app_vm_user_iam_policy_document.json
}

data "aws_iam_policy_document" "app_vm_user_iam_policy_document" {
  statement {
    actions = [
      "s3:ListAllMyBuckets",
      "ecr:GetAuthorizationToken",
      "s3:HeadBucket"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "ecr:DescribeImageScanFindings",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:ListTagsForResource",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetRepositoryPolicy",
      "ecr:GetLifecyclePolicy"
    ]
    resources = concat(
      [for repository in aws_ecr_repository.ecr_repositories : repository.arn],                           # All ECR repositories
      ["${aws_s3_bucket.app_docker_composes_bucket.arn}/*", aws_s3_bucket.app_docker_composes_bucket.arn] # S3 bucket with Docker Compose files
    )
  }
}
