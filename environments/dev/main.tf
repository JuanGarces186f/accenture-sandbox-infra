terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  
  backend "gcs" {
    bucket = "sandbox-terraform-state-dev"
     prefix = "terraform/state"
  }
}


provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# Genera el password de la base de datos en el root module
resource "random_password" "db_password" {
  length  = 24
  special = false
}

# Database
module "database" {
  source = "../../modules/database"

  instance_name       = var.db_instance_name
  region              = var.region
  zone                = var.db_zone
  database_name       = var.database_name
  database_user       = var.database_user
  database_password   = random_password.db_password.result
  private_network     = var.private_network
  environment         = var.environment
  labels              = var.labels
  authorized_networks = var.db_authorized_networks
  tier               = var.tier
  backup_enabled     = var.backup_enabled
  disk_size          = var.disk_size
  disk_type          = var.disk_type
  availability_type  = var.availability_type
  backup_retention   = var.backup_retention
}



# Secrets
module "secrets" {
  source = "../../modules/secrets"

  environment = var.environment
  labels      = var.labels
  db_password = random_password.db_password.result
}



# Artifact Registry
module "artifact_registry" {
  source = "../../modules/artifact_registry"

  region          = var.region
  repository_name = var.artifact_registry_name
  environment     = var.environment
  labels          = var.labels
}

 # Definición de nombres de servicios
  locals {
    franquicias = "franquicias-service-${var.environment}"
  }


# Cloud Run - (usando service_base)
module "franquicias-service" {
  source       = "../../modules/cloud_run/service_base"
    service_name = local.franquicias
    image_url    = "us-central1-docker.pkg.dev/${var.project_id}/${module.artifact_registry.repository_name}/${local.learning_service_name}:latest"
  region       = var.region
  cpu          = "1"
  memory       = "512Mi"

  envs = merge(
    {
      SPRING_PROFILES_ACTIVE=var.environment
      DB_HOST = module.database.public_ip_address
      DB_NAME = var.database_name
      DB_USER = var.database_user
    }
  )

  secrets = {
    DB_PASS = {
      name = "db-password-dev" # nombre del secret en Secret Manager
      key  = "latest"
    }
    # Agrega más secrets si es necesario
  }
}
