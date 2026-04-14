resource "google_cloud_run_service" "this" {
  name     = var.service_name
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"     = "20"
        "run.googleapis.com/startup-cpu-boost" = "true"
      }
    }
    spec {
      containers {
        image = var.image_url
        resources {
          limits = {
            cpu    = var.cpu
            memory = var.memory
          }
        }
        dynamic "env" {
          for_each = var.envs
          content {
            name  = env.key
            value = env.value
          }
        }
        dynamic "env" {
          for_each = var.secrets
          content {
            name = env.key
            value_from {
              secret_key_ref {
                name = env.value.name
                key  = env.value.key
              }
            }
          }
        }
      }
      container_concurrency = 80
      timeout_seconds       = 300
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "public_invoker" {
  location = google_cloud_run_service.this.location
  service  = google_cloud_run_service.this.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
