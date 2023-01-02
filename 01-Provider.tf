# AWS Provider Config
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Region Setting
provider "aws" {
  region = var.region
}