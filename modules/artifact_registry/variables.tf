variable "region" {
  description = "GCP region for the artifact registry"
  type        = string
}

variable "repository_name" {
  description = "Name of the artifact registry repository"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the repository"
  type        = map(string)
  default     = {}
}
