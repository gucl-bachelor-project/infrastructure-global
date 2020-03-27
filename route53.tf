# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY ROUTE 53 CONFIG FOR APPLICATION
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# CONNECT TO EXISTING MANAGED HOSTED ZONE
# Note: It should NOT be managed by Terraform in this project
# ------------------------------------------------------------------------------
data "aws_route53_zone" "gustavclausen_zone" {
  name         = "gustavclausen.com."
  private_zone = false
}

# ------------------------------------------------------------------------------
# CREATE NAMESPACE RECORDS TO POINT TO DIGITALOCEAN
# ------------------------------------------------------------------------------
resource "aws_route53_record" "www" {
  for_each = {
    production = "bproject.gustavclausen.com"
    staging    = "staging.bproject.gustavclausen.com"
  }

  allow_overwrite = true
  name            = each.value
  ttl             = 30
  type            = "NS"
  zone_id         = data.aws_route53_zone.gustavclausen_zone.zone_id

  records = [
    "ns1.digitalocean.com.",
    "ns2.digitalocean.com.",
    "ns3.digitalocean.com."
  ]
}

# ------------------------------------------------------------------------------
# OUTPUT URLS FOR STAGING AND PRODUCTION APP
# ------------------------------------------------------------------------------
output "staging_app_url" {
  value       = aws_route53_record.www["staging"].name
  description = "URL for application in staging"
}

output "production_app_url" {
  value       = aws_route53_record.www["production"].name
  description = "URL for application in production"
}
