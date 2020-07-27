# ------------------------------------------------------------------------------
# DEPLOY PRIVATE DIGITALOCEAN SPACES FOR PROJECT
# ------------------------------------------------------------------------------
resource "digitalocean_spaces_bucket" "project_bucket" {
  name   = "bproject-bucket"
  acl    = "private"
  region = var.do_spaces_region
}
