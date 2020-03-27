# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DATABASE CLUSTERS FOR DIFFERENT ENVIRONMENTS OF APPLICATION
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# MAP OF TAGS TO ASSIGN TO DIGITALOCEAN DROPLETS THAT SHOULD HAVE ACCESS TO
# ENVIRONMENT-SPECIFIC DB CLUSTER
# ------------------------------------------------------------------------------
locals {
  db_access_host_tags = {
    production  = "db-access-app-production"
    staging     = "db-access-app-staging"
    development = "db-access-app-development"
  }
}

# ------------------------------------------------------------------------------
# DEPLOY TAGS THAT CAN BE ASSIGNED TO DIGITALOCEAN DROPLETS THAT SHOULD HAVE
# ACCESS TO ENVIRONMENT-SPECIFIC DB CLUSTER
# ------------------------------------------------------------------------------
resource "digitalocean_tag" "allowed_droplet_tags" {
  for_each = local.db_access_host_tags

  name = each.value
}

# ------------------------------------------------------------------------------
# DB CLUSTER FOR PRODUCTION ENVIRONMENT
# ------------------------------------------------------------------------------
module "production_db" {
  source = "./do-mysql-db-single-node-cluster"

  cluster_name   = "bproject-prod-db"
  cluster_region = var.do_region
  cluster_maintenance_window = {
    day  = "friday"
    hour = "23:59:59"
  }
  allowed_droplet_tags = [digitalocean_tag.allowed_droplet_tags["production"].name]
  dbs                  = ["app-db-1", "app-db-2"]
  db_size              = "nano"
}

# ------------------------------------------------------------------------------
# DB CLUSTER FOR STAGING ENVIRONMENT
# ------------------------------------------------------------------------------
module "staging_db" {
  source = "./do-mysql-db-single-node-cluster"

  cluster_name         = "bproject-staging-db"
  cluster_region       = var.do_region
  allowed_droplet_tags = [digitalocean_tag.allowed_droplet_tags["staging"].name]
  dbs                  = ["app-db-1", "app-db-2"]
  db_size              = "nano"
}

# ------------------------------------------------------------------------------
# DB CLUSTER FOR DEVELOPMENT ENVIRONMENT
# ------------------------------------------------------------------------------
module "development_db" {
  source = "./do-mysql-db-single-node-cluster"

  cluster_name         = "bproject-dev-db"
  cluster_region       = var.do_region
  allowed_droplet_tags = [digitalocean_tag.allowed_droplet_tags["development"].name]
  dbs                  = ["app-db-1", "app-db-2"]
  db_size              = "nano"
}

output "db_clusters" {
  value = {
    production  = module.production_db
    staging     = module.staging_db
    development = module.development_db
  }
  description = "DigitalOcean DB clusters for all environments"
}

output "db_allowed_droplet_tags" {
  value = {
    production  = digitalocean_tag.allowed_droplet_tags["production"]
    staging     = digitalocean_tag.allowed_droplet_tags["staging"]
    development = digitalocean_tag.allowed_droplet_tags["development"]
  }
  description = "Tags that can be assigned to DigitalOcean Droplets that should have access to environment-specific DB cluster"
}
