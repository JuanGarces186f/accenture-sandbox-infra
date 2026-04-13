output "db_password_id" {
  description = "Secret Manager ID for database password"
  value       = google_secret_manager_secret.db_password.secret_id
}

output "db_password_name" {
  description = "Secret Manager name for database password"
  value       = google_secret_manager_secret.db_password.name
}


