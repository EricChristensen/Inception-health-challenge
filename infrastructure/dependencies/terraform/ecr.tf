terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "inception-health"
  region  = "us-east-1"

  default_tags {
    tags = {
      Author     = "Eric Christensen"
    }
  }
}


resource "aws_ecr_repository" "inception_health_repository" {
  name                 = "inception_health_repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}



