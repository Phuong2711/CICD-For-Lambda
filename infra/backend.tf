terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "phuong2711-terraform-bucket"
    key     = "infra/cicd-for-lambda/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}