output "artifact_registry_url" {
  description = "URL of the artifact registry repository"
  value       = module.artifact_registry.repository_url
}

output "database_connection_name" {
  description = "Database connection name"
  value       = module.database.instance_connection_name
}

output "database_public_ip" {
  description = "Database public IP address"
  value       = module.database.public_ip_address
}

output "database_host" {
  description = "Database host for application connection"
  value       = module.database.public_ip_address
}



