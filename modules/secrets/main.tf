# Secret en Secret Manager
resource "google_secret_manager_secret" "db_password" {
  secret_id = "db-password-${var.environment}"

  replication {
    auto {}
  }

  labels = merge(
    var.labels,
    {
      environment = var.environment
      managed_by  = "terraform"
      service     = "database"
    }
  )
}

# Versión del secret con el valor recibido desde el root
resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.db_password
}
