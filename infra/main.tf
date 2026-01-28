provider "aws" {
  region = "us-east-1"
}

# TERRAFORM MODULES
module "lambda" {
  source = "./modules/lambda"
  stage  = var.stage
}