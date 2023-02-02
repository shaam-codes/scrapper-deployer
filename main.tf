provider "aws" {
  region = var.aws_region
}

module "aws-collector" {
  source = "./modules/aws-collector"

  app_name = var.app_name
  app_environment = var.app_environment
}