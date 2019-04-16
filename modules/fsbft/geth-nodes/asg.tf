# ---------------------------------------------------------------------------------------------------------------------
# LAUNCH CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_launch_configuration" "geth-nodes" {
  name_prefix          = "${var.environment}-${var.project}-${var.role}-"
  image_id             = "${data.aws_ami.ami-geth-nodes.id}"
  instance_type        = "${var.nodes_instance_type}"
  security_groups      = ["${aws_security_group.geth-nodes.id}"]
  key_name             = "${var.ssh_key}"
  ebs_optimized        = false

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true

    # Ignore changes in the AMI which force recreation of the resource. This
    # avoids accidental deletion of nodes whenever a new CoreOS Release comes
    # out.
    ignore_changes = ["image_id"]
  }

  root_block_device {
    volume_type = "${var.nodes_root_volume_type}"
    volume_size = "${var.nodes_root_volume_size}"
    iops        = "${var.nodes_root_volume_type == "io1" ? var.nodes_root_volume_iops : 0}"
  }
}

data "aws_ami" "ami-geth-nodes" {
  most_recent = true
  owners      = ["765677258940"] 

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
    values = ["${var.geth_ami_name}"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ASG
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "geth-nodes" {
  name                 = "${var.environment}-${var.project}-${var.role}"
  launch_configuration = "${aws_launch_configuration.geth-nodes.id}"
  availability_zones   = ["${data.aws_availability_zones.available.names}"]
  vpc_zone_identifier  = ["${element(data.aws_subnet_ids.fsbft-public.ids, count.index)}"]
  #vpc_zone_identifier       = ["${ split(",", var.private_subnet_ids) }"]

  health_check_type = "EC2"
  health_check_grace_period = 30
  min_size = "${var.instance_min_size}"
  max_size = "${var.instance_max_size}"
  desired_capacity = "${var.instance_desired_capacity}"

  tags = [
    {
      key                 = "Name"
      value               = "${var.environment}-${var.project}-${var.role}"
      propagate_at_launch = true
    },
    {
      key                 = "BuiltWith"
      value               = "Terraform"
      propagate_at_launch = true
    },
    "${var.autoscaling_group_extra_tags}",
  ]
}

data "aws_subnet_ids" "fsbft-public" {
  vpc_id = "${data.aws_vpc.fsbft-vpc.id}"

  tags = {
    Project = "${var.project}"
    Environment = "${var.environment}",
    SubnetType = "public"
  }
}

data "aws_availability_zones" "available" { }

