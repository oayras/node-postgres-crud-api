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
