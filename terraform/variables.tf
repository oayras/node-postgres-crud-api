variable "execution_role_arn" {
  description = "ARN del ECS Execution Role existente"
  type        = string
}

variable "environment" {
  description = "Could be (dev, staging, prod)"
  type        = string
}

variable "repoName" {
  description = "Nombre de app"
  type        = string
}

variable "image" {
  description = "Image de app"
  type        = string
}

variable "appPort" {
  description = "port de app"
  type        = number
}

variable "fqdn" {
  description = "fqdn"
  type        = string
}

variable "aws_region" {
  type = string
  description = "AWS region"
}

variable "cloudwatch_loggroup" {
  type = string
  description = "Log group for cloudwatch"
}