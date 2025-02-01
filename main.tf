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

resource "aws_s3_bucket" "my_bucket" {
  bucket = "mi-bucket-ejemplo-terraform"  # Cambia esto a un nombre único

  tags = {
    Name        = "MyS3Bucket"
    Environment = "Development"
  }
}