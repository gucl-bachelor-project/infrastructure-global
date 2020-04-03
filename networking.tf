# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEFINE NETWORKING FOR APPLICATION
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# DNS CONFIG: CONNECT TO EXISTING MANAGED AMAZON ROUTE 53 HOSTED ZONE
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
# Record is created in domain and pointed to floating IP for VM in application
# tier in production environment receiving the incoming traffic from clients.
# ------------------------------------------------------------------------------
resource "digitalocean_domain" "domain" {
  name = aws_route53_record.www.name
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_floating_ip.prod_app_ip.ip_address
}

# ------------------------------------------------------------------------------
# DEPLOY FLOATING IPs FOR APPLICATION
# ------------------------------------------------------------------------------
resource "digitalocean_floating_ip" "prod_app_ip" {
  region = var.do_region
}

resource "digitalocean_floating_ip" "logging_app_ip" {
  region = var.do_region
}

output "app_ips" {
  value = {
    prod_app_ip    = digitalocean_floating_ip.prod_app_ip
    logging_app_ip = digitalocean_floating_ip.logging_app_ip
  }
  description = "Floating IPv4 addresses for application"
}
