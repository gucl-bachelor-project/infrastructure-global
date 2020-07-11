# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SSH KEYS THAT MUST HAVE ACCESS TO VMS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "digitalocean_ssh_key" "vm_ssh_keys" {
  for_each = {
    "gucl-macbook" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkakaejSIEI9KEQbHu+0waIYpNsin0Bg5VShXa8ORE00kpGCR+wN3sceACnSkqSYwpK8Ih2y2WIHPdDR6tr9YpiNYL6jjnI4WknEv5jZZU9kmI+N1bP4mxQS3G6Mt/PMla/pG55DLoG5ocSM4abkToddl2nsRBG826RTJg0SzzDsKYCXBki+BF8AdR0ViLKnQjHNK0vO6BHQ4ypDa7/9UPS4+B2LkDeZqQn+0aq8+dqsfWnb4MU1cFJM6wTwKZCgjH+O+Y5CuxQPsVYtPeD5o432461rJmnV1TD7XRq9bHtlpHA6O/nfhFz9UxBiR7XeQ/AnXcYOlH2OXYrxbb6Ka1 gustavclausen@Gustavs-MacBook-Pro.local"
  }

  name       = each.key
  public_key = each.value
}
