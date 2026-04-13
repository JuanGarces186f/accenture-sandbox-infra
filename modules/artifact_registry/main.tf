resource "google_artifact_registry_repository" "backend_repo" {
  location      = var.region
  repository_id = "${var.repository_name}-${var.environment}"
  description   = "Repository for backend container images - ${var.environment}"
  format        = "DOCKER"

  labels = merge(
    var.labels,
    {
      environment = var.environment
    }
  )
}
