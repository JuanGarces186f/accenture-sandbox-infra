variable "instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
}

variable "region" {
  description = "GCP region for the database instance"
  type        = string
}

variable "zone" {
  description = "GCP zone for the database instance"
  type        = string
  default     = "us-central1-c"
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
}

variable "database_user" {
  description = "Database user name"
  type        = string
}

variable "database_password" {
  description = "Database user password"
  type        = string
  sensitive   = true
}

variable "private_network" {
  description = "VPC network for private IP (optional)"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the database instance"
  type        = map(string)
  default     = {}
}

variable "authorized_networks" {
  description = "List of authorized networks that can access the database"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "tier" {
  description = "Tipo de máquina para la base de datos (ej: db-f1-micro, db-custom-2-7680, etc.)"
  type        = string
  default     = "db-f1-micro"
}

variable "backup_enabled" {
  description = "¿Habilitar backups automáticos?"
  type        = bool
  default     = false
}

variable "disk_size" {
  description = "Tamaño del disco en GB"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Tipo de disco (PD_SSD, PD_HDD)"
  type        = string
  default     = "PD_SSD"
}

variable "availability_type" {
  description = "Tipo de disponibilidad (ZONAL, REGIONAL)"
  type        = string
  default     = "ZONAL"
}

variable "backup_retention" {
  description = "Cantidad de backups a retener"
  type        = number
  default     = 7
}
