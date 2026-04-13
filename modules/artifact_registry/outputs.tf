output "repository_id" {
  description = "The ID of the repository"
  value       = google_artifact_registry_repository.backend_repo.id
}

output "repository_name" {
  description = "The name of the repository"
  value       = google_artifact_registry_repository.backend_repo.name
}

output "repository_url" {
  description = "The URL of the repository"
  value       = "${var.region}-docker.pkg.dev/${google_artifact_registry_repository.backend_repo.project}/${google_artifact_registry_repository.backend_repo.repository_id}"
}
