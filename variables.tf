# Common or system level variables

variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "ap-south-1"
}