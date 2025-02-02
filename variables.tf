variable "execution_role_arn" {
  description = "ARN del ECS Execution Role existente"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
}

variable "name" {
  description = "Nombre de app"
  type        = string
}

variable "image" {
  description = "Image de app"
  type        = string
}

variable "port" {
  description = "port de app"
  type        = number
}

variable "fqdn" {
  description = "fqdn"
  type        = string
}
