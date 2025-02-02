# variable "vpc_id" {
#   description = "ID of the VPC"
#   type        = string
# }

# variable "alb_name" {
#   description = "Names of the Application Load Balancer"
#   type        = string
# }

variable "execution_role_arn" {
  description = "ARN del ECS Execution Role existente"
  type        = string
}

# variable "cluster_name" {
#   description = "Nombre del cluster ECS existente"
#   type        = string
# }

# variable "private_subnet_ids" {
#   description = "IDs de las subnets privadas"
#   type        = list(string)
# }

# variable "ecs_tasks_security_group_id" {
#   description = "ID del Security Group existente para las tareas ECS"
#   type        = string
# }

# variable "target_group_arn" {
#   description = "ARN del Target Group existente"
#   type        = string
# }

# Variables más concisas y agrupadas
variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
}

variable "app" {
  description = "Configuración de la aplicación"
  type = object({
    name     = string
    image    = string
    port     = number
    cpu      = number
    memory   = number
  })
  default = {
    name     = "mi-aplicacion"
    image    = "mi-imagen:latest"
    port     = 80
    cpu      = 256
    memory   = 512
  }
}

