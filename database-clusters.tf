# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DATABASE CLUSTERS FOR APPLICATIONS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
  allowed_droplet_tags = ["db-access-app-production"]
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
  allowed_droplet_tags = ["db-access-app-staging"]
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
  allowed_droplet_tags = ["db-access-app-development"]
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
