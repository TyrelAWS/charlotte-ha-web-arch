terraform {
  required_version = ">= 1.5.0" # Keeps your core engine modern
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"        # This is the "pin"
    }
  }
}

provider "aws" {
  region = var.aws_region
}