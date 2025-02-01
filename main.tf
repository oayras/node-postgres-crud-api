# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "quantum2025"

    workspaces {
      name = "wsp-init-provisioning"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_lb_target_group" "fargate_tg" {
  name        = "fargate-tg"
  target_type = "ip"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

# Obtener el ARN del listener a partir del ALB
data "aws_lb" "existing_alb" {
  name = var.alb_name
}

data "aws_lb_listener" "https_listener" {
  load_balancer_arn = data.aws_lb.existing_alb.arn
  port              = 443
}

# Crear la regla en el listener
resource "aws_lb_listener_rule" "host_based_routing" {
  listener_arn = data.aws_lb_listener.https_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate_tg.arn
  }

  condition {
    host_header {
      values = ["oayras.footydao.xyz"]
    }
  }
}
