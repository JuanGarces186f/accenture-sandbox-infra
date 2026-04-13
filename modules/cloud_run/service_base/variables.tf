variable "service_name" {
  description = "Nombre del servicio de Cloud Run"
  type        = string
}

variable "image_url" {
  description = "URL de la imagen de contenedor"
  type        = string
}

variable "region" {
  description = "Región de despliegue"
  type        = string
  default     = "us-central1"
}

variable "cpu" {
  description = "Cantidad de CPU (por ejemplo, '1', '2')"
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Cantidad de memoria (por ejemplo, '512Mi', '1Gi')"
  type        = string
  default     = "512Mi"
}

variable "envs" {
  description = "Variables de entorno (mapa)"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secrets de Secret Manager (mapa: nombre_env -> { name, key })"
  type = map(object({
    name = string
    key  = string
  }))
  default = {}
}
