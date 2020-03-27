variable "cluster_name" {
  type        = string
  description = "Name of DB cluster"
}

variable "cluster_region" {
  type        = string
  description = "DigitalOcean region to place DB cluster in"
}

variable "cluster_maintenance_window" {
  type = object({
    day  = string
    hour = string
  })
  default = {
    day  = "sunday"
    hour = "00:00:00"
  }
  description = "Time of week when DigitalOcean can maintain the cluster with updates, fixes, etc. Defaults to Sunday at midnight."
}

variable "allowed_droplet_tags" {
  type        = list(string)
  description = "List of tags (that can be assigned to DigitalOcean droplets) that provide access to the DB cluster"
}

variable "dbs" {
  type        = list(string)
  description = "List of MySQL databases (with its name) to create in cluster"
}

variable "db_size" {
  type        = string
  default     = "nano"
  description = "Size of DB cluster. Allowed values: `nano` (RAM: 1 GB, CPU: 1 vCPU, Storage: 10 GB), `small` (RAM: 2 GB, CPU: 1 vCPU, Storage: 25 GB), or `medium` (RAM: 4 GB, CPU: 2 vCPU, Storage: 38 GB)"
}
