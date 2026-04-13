variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# Artifact Registry Variables
variable "artifact_registry_name" {
  description = "Name of the artifact registry repository"
  type        = string
}

# Database Variables
variable "db_instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
}

variable "db_zone" {
  description = "GCP zone for the database instance"
  type        = string
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
}

variable "database_user" {
  description = "Database user name"
  type        = string
}

variable "private_network" {
  description = "VPC network for private IP (optional)"
  type        = string
  default     = null
}

variable "db_authorized_networks" {
  description = "Authorized networks for database access"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "allow-all-dev"
      value = "0.0.0.0/0"
    }
  ]
}


# Labels
variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default = {
    managed_by = "terraform"
    project    = "sandbox"
  }
}


# Database Configuration Variables
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
