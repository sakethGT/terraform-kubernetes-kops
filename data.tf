# AMI lookup for CoreOS stable.
# Note: CoreOS Container Linux reached end-of-life in May 2020.
# The modern successor is Flatcar Container Linux, which is a drop-in replacement
# that maintains full compatibility with Ignition and Container Linux configs.
# For new deployments, replace the AMI filter with Flatcar equivalents.

data "aws_ami" "coreos_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CoreOS-stable-1520.9.0-hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-id"
    values = ["595879546273"]
  }
}

data "aws_availability_zones" "azs" {}
data "aws_caller_identity" "current" {}
