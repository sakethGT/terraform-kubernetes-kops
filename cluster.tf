# Cluster specification rendered from template and stored in S3 for kops consumption.
# This defines the full cluster topology: networking, etcd, API server, and all
# Kubernetes component configurations.

locals {
  cluster_spec_vars = {
    cluster_name          = var.cluster_name
    config_bucket         = var.config_bucket
    cluster_zone_id       = var.cluster_zone_id
    private_subnet_a_cidr = element(var.private_subnet_cidrs, 0)
    private_subnet_a_id   = element(var.private_subnet_ids, 0)
    private_subnet_b_cidr = element(var.private_subnet_cidrs, 1)
    private_subnet_b_id   = element(var.private_subnet_ids, 1)
    private_subnet_c_cidr = element(var.private_subnet_cidrs, 2)
    private_subnet_c_id   = element(var.private_subnet_ids, 2)
    public_subnet_a_id    = element(var.public_subnet_ids, 0)
    public_subnet_a_cidr  = element(var.public_subnet_cidrs, 0)
    public_subnet_b_id    = element(var.public_subnet_ids, 1)
    public_subnet_b_cidr  = element(var.public_subnet_cidrs, 1)
    public_subnet_c_id    = element(var.public_subnet_ids, 2)
    public_subnet_c_cidr  = element(var.public_subnet_cidrs, 2)
    vpc_id                = var.vpc_id
    vpc_cidr              = var.vpc_cidr
  }
}

resource "aws_s3_object" "instancegroup_nodes" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/instancegroup/nodes"
  content = templatefile("${path.module}/data/instancegroup_nodes.tpl", {
    cluster_name = var.cluster_name
  })
}

resource "aws_s3_object" "instancegroup_masters" {
  count = 3

  bucket  = var.config_bucket
  key     = "${var.cluster_name}/instancegroup/master-us-east-1${substr(element(var.masters_availability_zones, count.index), -1, 1)}"
  content = templatefile("${path.module}/data/instancegroup_masters.tpl", {
    cluster_name = var.cluster_name
    az_id        = substr(element(var.masters_availability_zones, count.index), -1, 1)
  })
}

resource "aws_s3_object" "cluster_spec" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/cluster.spec"
  content = templatefile("${path.module}/data/cluster.spec", local.cluster_spec_vars)
}
