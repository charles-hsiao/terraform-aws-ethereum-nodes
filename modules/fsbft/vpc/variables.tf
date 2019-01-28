variable "aws_region" {}
variable "aws_profile" {}
variable "environment" {}
variable "project" {}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
}

