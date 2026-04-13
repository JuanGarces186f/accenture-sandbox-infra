variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "labels" {
  description = "Labels to apply to secrets"
  type        = map(string)
  default     = {}
}

variable "db_password" {
  description = "Database password to store in Secret Manager"
  type        = string
  sensitive   = true
}
