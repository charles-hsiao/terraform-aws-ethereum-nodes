# usage, you should lock the Instances down so they only allow traffic from trusted sources (e.g. the ELB).
# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that supports locking and enforces best
# practices: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

terragrunt = {
  # Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
  # working directory, into a temporary folder, and execute your Terraform commands in that folder.
  terraform {
    source = "../../../../../modules/fsbft//geth-nodes"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------

role = "geth-nodes"
ssh_key = "ssh-fsbft"

# geth-nodes
geth_ami_name = "geth-nodes-ubuntu-1804-*"
instance_min_size = 1
instance_max_size = 19
instance_desired_capacity = 1
nodes_instance_type = "t2.micro"
nodes_root_volume_type = "gp2"
nodes_root_volume_size = "16"
nodes_root_volume_iops = "100"

# geth-nodes-ct
ct_ami_name = "geth-nodes-ct-ubuntu-1804-*"
ct_instance_type = "t2.micro"
ct_root_volume_type = "gp2"
ct_root_volume_size = "8"
ct_root_volume_iops = "100"

extra_tags = {
  Project = "fsbft"
  Environment = "stag"
  Role = "geth-nodes"
}

autoscaling_group_extra_tags = [
  { key = "Project", value = "fsbft", propagate_at_launch = true },
  { key = "Environment", value = "stag", propagate_at_launch = true },
  { key = "Role", value = "geth-nodes", propagate_at_launch = true }
]
