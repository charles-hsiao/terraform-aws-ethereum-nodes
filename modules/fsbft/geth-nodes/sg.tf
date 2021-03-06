# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUPS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "fsbft-vpc" {
  tags = {
    Name = "${var.environment}-${var.project}-vpc"
  }
}

# EC2
resource "aws_security_group" "geth-nodes-ct" {
  name_prefix = "${var.environment}-${var.project}-${var.role}-ct-"
  vpc_id      = "${data.aws_vpc.fsbft-vpc.id}"

  tags = "${merge(map(
      "Name", "${var.environment}-${var.project}-${var.role}-ct",
      "BuiltWith", "Terraform",
    ), var.extra_tags)}"
}

resource "aws_security_group_rule" "egress-geth-nodes-ct" {
  type              = "egress"
  security_group_id = "${aws_security_group.geth-nodes-ct.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-geth-nodes-ct-ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.geth-nodes-ct.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "geth-nodes" {
  name_prefix = "${var.environment}-${var.project}-${var.role}-"
  vpc_id      = "${data.aws_vpc.fsbft-vpc.id}"

  tags = "${merge(map(
      "Name", "${var.environment}-${var.project}-${var.role}",
      "BuiltWith", "Terraform",
    ), var.extra_tags)}"
}

resource "aws_security_group_rule" "egress-geth-nodes" {
  type              = "egress"
  security_group_id = "${aws_security_group.geth-nodes.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-geth-nodes-ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.geth-nodes.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  source_security_group_id = "${aws_security_group.geth-nodes-ct.id}"
}

resource "aws_security_group_rule" "ingress-geth-nodes-peer-tcp" {
  type              = "ingress"
  security_group_id = "${aws_security_group.geth-nodes.id}"

  from_port   = 30301
  to_port     = 30351
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-geth-nodes-peer-udp" {
  type              = "ingress"
  security_group_id = "${aws_security_group.geth-nodes.id}"

  from_port   = 30301
  to_port     = 30351
  protocol    = "udp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-geth-nodes-rpc" {
  type              = "ingress"
  security_group_id = "${aws_security_group.geth-nodes.id}"

  from_port   = 8543
  to_port     = 8593
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
