resource "aws_vpc" "fsbft-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.environment}-${var.project}-vpc"
  }
}
