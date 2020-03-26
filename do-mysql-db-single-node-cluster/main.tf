# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SINGLE NODE MYSQL DB CLUSTER IN DIGITALOCEAN THAT CANNOT BE DESTROYED BY TERRAFORM ONCE CREATED
# Includes databases and user for application access
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# TRANSLATION OF CUSTOM DB SIZE TO VALID DB SIZE IN DIGITALOCEAN
# ------------------------------------------------------------------------------
locals {
  db_sizes = {
    nano   = "db-s-1vcpu-1gb"
    small  = "db-s-1vcpu-2gb"
    medium = "db-s-2vcpu-4gb"
  }
}

# ------------------------------------------------------------------------------
# CREATE MYSQL DB CLUSTER
# ------------------------------------------------------------------------------
resource "digitalocean_database_cluster" "mysql-cluster" {
  name       = var.cluster_name
  engine     = "mysql"
  version    = "8"
  size       = local.db_sizes[var.db_size]
  region     = var.cluster_region
  node_count = 1
  maintenance_window {
    day  = var.cluster_maintenance_window.day
    hour = var.cluster_maintenance_window.hour
  }

  # Disallow Terraform destroying the resources after having created them
  # lifecycle {
  # prevent_destroy = true
  # }
}

# ------------------------------------------------------------------------------
# CREATE APPLICATION USER FOR DB CLUSTER
# ------------------------------------------------------------------------------
resource "digitalocean_database_user" "app_db_user" {
  cluster_id = digitalocean_database_cluster.mysql-cluster.id
  name       = "app-user"
}

# ------------------------------------------------------------------------------
# CREATE DATABASES IN DB CLUSTER
# ------------------------------------------------------------------------------
resource "digitalocean_database_db" "database" {
  for_each = toset(var.dbs)

  cluster_id = digitalocean_database_cluster.mysql-cluster.id
  name       = each.key

  # Disallow Terraform destroying the resources after having created them
  # lifecycle {
  # prevent_destroy = true
  # }
}

# ------------------------------------------------------------------------------
# CREATE FIREWALL FOR DB CLUSTER
# ------------------------------------------------------------------------------
resource "digitalocean_database_firewall" "cluster_firewall" {
  cluster_id = digitalocean_database_cluster.mysql-cluster.id

  dynamic "rule" {
    for_each = toset(var.allowed_droplet_tags)

    content {
      type  = "tag"
      value = rule.key
    }
  }
}
