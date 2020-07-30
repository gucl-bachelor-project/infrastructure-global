# Infrastructure – Global stack

**Note:**  
- This Terraform project cannot be replicated as:
  - it uses existing infrastructure on AWS that is not managed by Terraform. See [website-domain.tf](website-domain.tf).
  - the reference to the remote state is hardcoded. The remote state setup is available in the following repository: https://github.com/gucl-bachelor-project/infrastructure-remote-state.
- The AWS region is hardcoded.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.69.0 |
| digitalocean | ~> 1.20.0 |
| template | ~> 2.1.2 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.69.0 |
| digitalocean | ~> 1.20.0 |
| template | ~> 2.1.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_access\_key | Access key of AWS credentials | `string` | n/a | yes |
| aws\_secret\_key | Secret key of AWS credentials | `string` | n/a | yes |
| do\_api\_token | API token for DigitalOcean to manage resources | `string` | n/a | yes |
| do\_region | Region to deploy DigitalOcean resources in | `string` | `"fra1"` | no |
| do\_spaces\_access\_key\_id | Access key to project's DigitalOcean Spaces bucket | `string` | n/a | yes |
| do\_spaces\_region | Region to deploy DigitalOcean Spaces in | `string` | `"ams3"` | no |
| do\_spaces\_secret\_access\_key | Secret key to project's DigitalOcean Spaces bucket | `string` | n/a | yes |
| pvt\_key | Path to private key on machine executing Terraform. The public key must be registered on DigitalOcean. See: [ssh-keys.tf](ssh-keys.tf) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| db\_allowed\_droplet\_tags | Name of tags that can be assigned to DigitalOcean Droplets (i.e. VMs) that should have access to environment-specific DB cluster |
| db\_clusters | DigitalOcean DB clusters for all environments |
| ecr\_region | AWS region where ECR registry is hosted |
| ecr\_registry\_base\_url | Base URL of ECR registry (registry URL without repository IDs). Example: 468374654130.dkr.ecr.eu-central-1.amazonaws.com' |
| ecr\_repositories | All ECR repositories |
| ips | IPv4 addresses for application |
| logging\_vm\_allowed\_droplet\_tag\_name | Name of tag that can be assigned to DigitalOcean Droplets (i.e. VMs) that should have access to the logging VM |
| project\_bucket\_name | The name of the project's DigitalOcean Spaces bucket |
| project\_bucket\_region | The slug of the region where the project's DigitalOcean Spaces bucket is stored. Example: 'ams3' |
| registered\_ssh\_keys\_names | List of names for registered SSH keys (in DigitalOcean) that should have SSH access to the deployed VMs |
