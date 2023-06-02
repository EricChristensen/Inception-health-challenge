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