variable "aws_region" {}
variable "aws_profile" {}
variable "environment" {}
variable "project" {}

variable "role" {}
variable "ssh_key" {}

# geth-nodes
variable "instance_min_size" {}
variable "instance_max_size" {}
variable "instance_desired_capacity" {}
variable "nodes_instance_type" {}
variable "nodes_root_volume_type" {}
variable "nodes_root_volume_size" {}
variable "nodes_root_volume_iops" {}

# geth-nodes-ct
variable "ct_instance_type" {}
variable "ct_root_volume_type" {}
variable "ct_root_volume_size" {}
variable "ct_root_volume_iops" {}

variable "extra_tags" {
  type = "map"
}
variable "autoscaling_group_extra_tags" {
  type = "list"
}
