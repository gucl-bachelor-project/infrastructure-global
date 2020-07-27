# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# AWS IDENTITY AND ACCESS MANAGEMENT (IAM) CONFIGURATION TO MANAGE ACCESS TO DEPLOYED RESOURCES ON AWS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# CREATE IAM USER FOR VMS THAT MUST ACCESS SERVICES ON AWS (E.G. TO FETCH
# DOCKER IMAGES)
# ------------------------------------------------------------------------------
resource "aws_iam_user" "app_vm_user" {
  name = "BprojectAppVMUser"
}

# ------------------------------------------------------------------------------
# COMPOSE IAM POLICY THAT ALLOWS ACCESS FOR ECR REPOSITORIES AND ATTACH THIS
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
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
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
    # Give access to all ECR repositories
    resources = [for repository in aws_ecr_repository.ecr_repositories : repository.arn]
  }
}
