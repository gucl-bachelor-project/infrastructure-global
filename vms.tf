# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# VMS AND THEIR CONFIGURATION (INCLUDING SECURITY, BOOT AND STORAGE CONFIG)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# DEPLOY VM FOR LOGGING APP
# ------------------------------------------------------------------------------
module "logging_vm" {
  source = "github.com/gucl-bachelor-project/infrastructure-modules//do-application-vm?ref=v1.0.0"

  vm_name             = "logging"
  boot_image_id       = data.digitalocean_droplet_snapshot.base_snapshot.id
  do_region           = var.do_region
  do_vm_size          = "s-1vcpu-1gb" # Micro
  authorized_ssh_keys = digitalocean_ssh_key.vm_ssh_keys
  app_start_script    = data.template_file.logging_vm_bootstrap_config.rendered
  aws_config = {
    region            = data.aws_region.current.name
    access_key_id     = aws_iam_access_key.app_vm_user_access_key.id
    secret_access_key = aws_iam_access_key.app_vm_user_access_key.secret
  }
}

# ------------------------------------------------------------------------------
# REFERENCE BAKED OS IMAGE THAT VMS BOOTS FROM
# ------------------------------------------------------------------------------
data "digitalocean_droplet_snapshot" "base_snapshot" {
  name_regex  = "^bproject-app-vm-image"
  region      = var.do_region
  most_recent = true
}

# ------------------------------------------------------------------------------
# CREATE AND ASSIGN BLOCK STORAGE TO LOGGING VM TO PERSIST LOGGING DATA
# ------------------------------------------------------------------------------
resource "digitalocean_volume" "logging_vm_block_storage" {
  region                  = var.do_region
  name                    = "logging-data"
  initial_filesystem_type = "xfs" # Best for performance in MongoDB. Source: https://docs.mongodb.com/manual/administration/production-notes/#platform-specific-considerations
  description             = "Persistent storage for logs"
  size                    = 1 # GB

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_volume_attachment" "logging_vm_block_storage_attachment" {
  droplet_id = module.logging_vm.id
  volume_id  = digitalocean_volume.logging_vm_block_storage.id
}

# ------------------------------------------------------------------------------
# CLOUD INIT CONFIG SCRIPT FOR LOGGING VM.
# To be run when the VM boots for the first time.
# ------------------------------------------------------------------------------
data "template_file" "logging_vm_bootstrap_config" {
  template = file("${path.module}/vm-config-scripts/logging-vm-config.tpl")

  vars = {
    ecr_base_url                 = local.ecr_registry_base_url
    app_docker_compose_bucket_id = aws_s3_bucket.app_docker_composes_bucket.id
    logging_app_repo_url         = aws_ecr_repository.ecr_repositories["logging-app"].repository_url
    block_storage_name           = digitalocean_volume.logging_vm_block_storage.name
    block_storage_mount_name     = replace(digitalocean_volume.logging_vm_block_storage.name, "-", "_") # All dash becomes underscore
  }
}

# ------------------------------------------------------------------------------
# ASSIGN FLOATING IP TO LOGGING VM
# ------------------------------------------------------------------------------
resource "digitalocean_floating_ip_assignment" "logging_vm_floating_ip_assignment" {
  ip_address = digitalocean_floating_ip.logging_vm.ip_address
  droplet_id = module.logging_vm.id
}

# ------------------------------------------------------------------------------
# CREATE AND ASSIGN FIREWALL TO LOGGING VM
# ------------------------------------------------------------------------------
resource "digitalocean_firewall" "logging_vm_firewall" {
  name        = "logging-vm-firewall"
  droplet_ids = [module.logging_vm.id]

  # Inbound SSH traffic from all IPs allowed
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Inbound TCP traffic allowed for Droplets (i.e. VMs) with tag that gives access to VM
  inbound_rule {
    protocol    = "tcp"
    port_range  = "1-65535"
    source_tags = [digitalocean_tag.logging_vm_access_allowed_droplet_tag.name]
  }

  # Outbound TCP/UDP/ICMP traffic to all IPs allowed
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# ------------------------------------------------------------------------------
# CREATE TAG THAT CAN BE ASSIGNED TO DROPLETS (i.e. VMS) THAT MUST ACCESS
# LOGGING VM
# ------------------------------------------------------------------------------
resource "digitalocean_tag" "logging_vm_access_allowed_droplet_tag" {
  name = "logging-vm-access"
}
