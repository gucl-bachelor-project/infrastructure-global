output "db_cluster" {
  value       = digitalocean_database_cluster.mysql_cluster
  description = "Created MySQL DB cluster"
}

output "dbs" {
  value       = digitalocean_database_db.databases
  description = "Created MySQL databases within DB cluster"
}

output "app_user" {
  value       = digitalocean_database_user.app_db_user
  description = "Created MySQL DB user for application access"
}
