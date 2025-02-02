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

# Data sources para recursos existentes
data "aws_vpc" "selected" {
  tags = {
    Environment = var.environment
    Reason = migration
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  tags = {
    Environment = var.environment
    Tier       = "private"
    Reason = "migration"
  }
}

data "aws_ecs_cluster" "existing" {
  cluster_name = "${var.environment}Cluster"
}

data "aws_security_group" "ecs_tasks" {
  vpc_id = data.aws_vpc.selected.id
  tags = {
    Name        = "sg-${var.environment}-ecs-tasks"
    Environment = var.environment
    Reason = "migration"
  }
}

resource "aws_lb_target_group" "fargate_tg" {
  name        = "service-${var.app.name}"
  target_type = "ip"
  port        = var.app.port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

data "aws_lb" "existing" {
  tags = {
    Name        = "lb-${var.environment}-01"
    Environment = var.environment
    Reason = "migration"
  }
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

resource "aws_ecs_task_definition" "app" {
  family                   = "def-${var.app.name}"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = 256
  memory                  = 512
  execution_role_arn      = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.app.name
      image     = var.app.image  # Reemplaza con tu imagen
      essential = true
      portMappings = [
        {
          containerPort = var.app.port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app.name}"
          "awslogs-region"        = "ap-southeast-1"  # Reemplaza con tu región
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "app" {
  name            = "service-${var.app.name}"
  cluster         = data.aws_ecs_cluster.existing.cluster_name
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.private.ids
    security_groups  = [data.aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fargate_tg.arn
    container_name   = var.app.name
    container_port   = var.app.port
  }
}