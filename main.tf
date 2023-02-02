provider "aws" {
  region = var.aws_region
}

module "aws-collector" {
  source = "./modules/aws-collector"
}