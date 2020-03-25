output "db_cluster" {
  value       = digitalocean_database_cluster.mysql-cluster
  description = "DigitalOcean DB cluster"
}

output "dbs" {
  value       = digitalocean_database_db.database
  description = "MySQL databases within DB cluster"
}

output "app_user" {
  value       = digitalocean_database_user.app_db_user
  description = "MySQL DB user for applications"
}
