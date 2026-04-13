output "cloud_run_url" {
  description = "URL del servicio Cloud Run"
  value       = google_cloud_run_service.this.status[0].url
}

output "cloud_run_service_name" {
  description = "Nombre del servicio Cloud Run"
  value       = google_cloud_run_service.this.name
}
