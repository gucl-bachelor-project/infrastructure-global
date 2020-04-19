# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY VMs
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# REFERENCE BAKED OS IMAGE TO BOOT VMs ON
# ------------------------------------------------------------------------------
data "digitalocean_droplet_snapshot" "base_snapshot" {
  name_regex  = "^gkc-bproject-packer"
  region      = "fra1"
  most_recent = true
}

# ------------------------------------------------------------------------------
# DEPLOY VM FOR LOGGING APPLICATION
# ------------------------------------------------------------------------------
module "logging_vm" {
  source = "github.com/gucl-bachelor-project/infrastructure-modules//do-application-vm?ref=v1.0.0"

  vm_name             = "logging"
  boot_image_id       = data.digitalocean_droplet_snapshot.base_snapshot.id
  do_region           = var.do_region
  do_vm_size          = "s-1vcpu-1gb" # Micro
  authorized_ssh_keys = digitalocean_ssh_key.ssh_keys
  app_start_script    = data.template_file.logging_app_bootstrap_config.rendered
  aws_config = {
    region            = data.aws_region.current.name
    access_key_id     = var.vm_user_aws_access_key_id
    secret_access_key = var.vm_user_aws_secret_access_key
  }
}

# ------------------------------------------------------------------------------
# CLOUD INIT CONFIG SCRIPT TO START THE LOGGING APPLICATION ON VM.
# To be run when the VM boots for the first time.
# ------------------------------------------------------------------------------
data "template_file" "logging_app_bootstrap_config" {
  template = file("${path.module}/app-start-scripts/logging-app-bootstrap.tpl")

  vars = {
    ecr_base_url                 = local.ecr_base_url
    app_docker_compose_bucket_id = aws_s3_bucket.app_docker_composes_bucket.id
    logging_app_repo_url         = aws_ecr_repository.ecr_repositories["logging-app"].repository_url
    block_storage_name           = digitalocean_volume.prod_log_block_storage.name
    block_storage_mount_name     = replace(digitalocean_volume.prod_log_block_storage.name, "-", "_") # All dash becomes underscore
  }
}

# ------------------------------------------------------------------------------
# ATTACH PERSISTENT BLOCK STORAGE TO LOGGING APP VM
# ------------------------------------------------------------------------------
resource "digitalocean_volume_attachment" "logging_data_block_attachment" {
  droplet_id = module.logging_vm.id
  volume_id  = digitalocean_volume.prod_log_block_storage.id
}

# ------------------------------------------------------------------------------
# ASSIGN FLOATING IP TO LOGGING APP VM
# ------------------------------------------------------------------------------
resource "digitalocean_floating_ip_assignment" "logging_app_floating_ip_assignment" {
  ip_address = digitalocean_floating_ip.logging_app_ip.ip_address
  droplet_id = module.logging_vm.id
}
