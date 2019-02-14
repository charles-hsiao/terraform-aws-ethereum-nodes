# ---------------------------------------------------------------------------------------------------------------------
# EC2
# ---------------------------------------------------------------------------------------------------------------------

# Control Tower(Experiment Server) & SSH Gateway
resource "aws_instance" "geth-nodes-ct" {
  ami           = "${data.aws_ami.ami-geth-nodes-ct.id}"
  instance_type = "${var.ct_instance_type}"
  key_name = "${var.ssh_key}"
  count = 1
  vpc_security_group_ids = [ "${aws_security_group.geth-nodes-ct.id}" ]
  subnet_id = "${element(data.aws_subnet_ids.fsbft-public.ids, count.index)}"
  monitoring = false

  root_block_device {
    volume_type = "${var.ct_root_volume_type}"
    volume_size = "${var.ct_root_volume_size}"
    iops        = "${var.ct_root_volume_type == "io1" ? var.ct_root_volume_iops : 0}"
  }

  tags = "${merge(map(
    "Name", "${var.environment}-${var.project}-${var.role}-ct",
    "BuiltWith", "Terraform",
  ), var.extra_tags)}"

  volume_tags = "${merge(map(
    "Name", "${var.environment}-${var.project}-${var.role}-ct",
    "BuiltWith", "Terraform",
  ), var.extra_tags)}"

}

# TODO: Use Packer AMI later
# Official Ubuntu 16.04
data "aws_ami" "ami-geth-nodes-ct" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}
