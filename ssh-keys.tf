# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# REGISTER SSH KEYS FOR APPLICATION VM ACCESS 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "digitalocean_ssh_key" "ssh_keys" {
  for_each = {
    "gkc-macbook" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs+yErYPSUsX+uwn7nbo7xzzqBLADGPyhsOwwZ+g/Mqxw24P8qo4YG/Ypza62fIxwmmoOnXpDFemSDaU4w0N0XTODnLkjaxpc4g/fT6b7AlTyUKZLv75piYqC7qhnZmtP/USUvHBiE5KDBTSryFPX0WtGRLoE1H/ucpGqKsPDabp2EAW7PfF5c9x6THwvwfetpngwoJr2i/XV3BZsOZgGhxsPKLnqhwy2tQsE/8yxEhGgPerYq5H0OC+btcv9dDa0dyVojGmFwlM2AjbhnyGIefSvkpQW9m1bItcTevTKlI9f2AcOwZpq+YVMQ89/SGSeRqcTC3OnFKVMhPAbtQrfh gustavkc@Gustavs-MacBook-Pro.local"
  }

  name       = each.key
  public_key = each.value
}
