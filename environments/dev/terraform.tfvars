# GCP Project Configuration
project_id = "jpablog-sandbox" 
region     = "us-central1"
environment = "dev"

# Artifact Registry
artifact_registry_name = "accenture-sandbox-backend-repo"

# Database Configuration
db_instance_name  = "accenture_sandbox"
database_name     = "accenture_sandbox_db"
database_user     = "accenture_sandbox_user"

# Configuración de la base de datos parametrizada
# se ajusta estos valores según el ambiente
tier             = "db-f1-micro"
backup_enabled   = false
disk_size        = 10
disk_type        = "PD_SSD"
db_zone          =  "us-central1-c"
availability_type = "ZONAL"
backup_retention = 7


# Labels
labels = {
  managed_by  = "terraform"
  project     = "accenture-sandbox"
  environment = "dev"
}




