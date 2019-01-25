# VPC
resource "aws_vpc" "fsbft-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.environment}-${var.project}-vpc"
  }
}

# Public subnet
resource "aws_subnet" "fsbft-public-subnet-a" {
  vpc_id = "${aws_vpc.fsbft-vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "${var.environment}-${var.project}-public-a"
  }
}
