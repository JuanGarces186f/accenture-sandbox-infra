resource "google_sql_database_instance" "postgres" {
  name             = "${var.instance_name}-${var.environment}"
  database_version = "POSTGRES_17"
  region           = var.region
  instance_type    = "CLOUD_SQL_INSTANCE"

  settings {

    tier                = var.tier
    edition             = "ENTERPRISE"
    availability_type   = var.availability_type
    activation_policy   = "ALWAYS"
    pricing_plan        = "PER_USE"

    disk_size             = var.disk_size
    disk_type             = var.disk_type
    disk_autoresize       = true
    disk_autoresize_limit = 0

    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = "09:00"
      transaction_log_retention_days = 7
      
      backup_retention_settings {
        retained_backups = var.backup_retention
        retention_unit   = "COUNT"
      }
    }

    ip_configuration {
      ipv4_enabled    = true
      private_network = var.private_network
      ssl_mode        = "ENCRYPTED_ONLY"
      
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    location_preference {
      zone = var.zone
    }

    connector_enforcement = "NOT_REQUIRED"

    user_labels = merge(
      var.labels,
      {
        environment = var.environment
      }
    )
  }

  deletion_protection = false
}

resource "google_sql_database" "database" {
  name     = "${var.database_name}_${var.environment}"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "user" {
  name     = var.database_user
  instance = google_sql_database_instance.postgres.name
  password = var.database_password
}
