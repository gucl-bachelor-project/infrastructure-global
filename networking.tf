# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEFINE NETWORKING FOR APPLICATION
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# DEPLOY FLOATING IPs FOR APPLICATION
# ------------------------------------------------------------------------------
resource "digitalocean_floating_ip" "floating_ips" {
  for_each = toset(["prod_app_ip", "logging_app_ip"])

  region = var.do_region
}

output "app_ips" {
  value       = digitalocean_floating_ip.floating_ips
  description = "Floating IPv4 addresses for application"
}
