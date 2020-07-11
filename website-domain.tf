# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# WEBSITE DOMAIN CONFIG
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# DNS CONFIG: REFERENCE EXISTING MANAGED AMAZON ROUTE 53 HOSTED ZONE
# Note: It should NOT be managed by Terraform in this project
# ------------------------------------------------------------------------------
data "aws_route53_zone" "gustavclausen_zone" {
  name         = "gustavclausen.com."
  private_zone = false
}

# ------------------------------------------------------------------------------
# DNS CONFIG: CREATE NAMESPACE RECORDS IN AMAZON ROUTE 53 TO POINT TO
# DIGITALOCEAN
# ------------------------------------------------------------------------------
resource "aws_route53_record" "www" {
  allow_overwrite = true
  name            = "bproject.gustavclausen.com"
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
# CREATE DOMAIN AND RECORDS IN DIGITALOCEAN.
# A 'A'-record is created in the domain config and pointed to floating IP for
# VM in application tier (i.e. the server hosting the business logic subsystem)
# in production environment receiving the incoming traffic from clients.
# ------------------------------------------------------------------------------
resource "digitalocean_domain" "domain" {
  name = aws_route53_record.www.name
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_floating_ip.prod_website.ip_address
}
