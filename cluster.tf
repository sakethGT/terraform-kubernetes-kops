data "template_file" "cluster_spec" {
  template = "${file("${path.module}/data/cluster.spec")}"

  vars {
    cluster_name          = "${var.cluster_name}"
    config_bucket         = "${var.config_bucket}"
    cluster_zone_id       = "${var.cluster_zone_id}"
    private_subnet_a_cidr = "${element(var.private_subnet_cidrs, 1)}"
    private_subnet_a_id   = "${element(var.private_subnet_ids, 1)}"
    private_subnet_b_cidr = "${element(var.private_subnet_cidrs, 2)}"
    private_subnet_b_id   = "${element(var.private_subnet_ids, 2)}"
    private_subnet_c_cidr = "${element(var.private_subnet_cidrs, 3)}"
    private_subnet_c_id   = "${element(var.private_subnet_ids, 3)}"
    public_subnet_a_id    = "${element(var.public_subnet_ids, 1)}"
    public_subnet_a_cidr  = "${element(var.public_subnet_cidrs, 1)}"
    public_subnet_b_id    = "${element(var.public_subnet_ids, 2)}"
    public_subnet_b_cidr  = "${element(var.public_subnet_cidrs, 2)}"
    public_subnet_c_id    = "${element(var.public_subnet_ids, 3)}"
    public_subnet_c_cidr  = "${element(var.public_subnet_cidrs, 3)}"
    vpc_id                = "${var.vpc_id}"
    vpc_cidr              = "${var.vpc_cidr}"
  }
}

data "template_file" "instancegroup_masters" {
  count    = 3
  template = "${file("${path.module}/data/instancegroup_masters.tpl")}"

  vars {
    cluster_name = "${var.cluster_name}"
    az_id        = "${substr(element(var.masters_availability_zones, count.index), -1, 1)}"
  }
}

data "template_file" "instancegroup_nodes" {
  template = "${file("${path.module}/data/instancegroup_nodes.tpl")}"

  vars {
    cluster_name = "${var.cluster_name}"
  }
}

resource "aws_s3_bucket_object" "instancegroup_nodes" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/instancegroup/nodes"
  content = "${data.template_file.instancegroup_nodes.rendered}"
}

resource "aws_s3_bucket_object" "instancegroup_masters" {
  count = 3

  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/instancegroup/master-us-east-1${substr(element(var.masters_availability_zones,count.index), -1, 1)}"
  content = "${element(data.template_file.instancegroup_masters.*.rendered, count.index)}"
}

resource "aws_s3_bucket_object" "cluster_spec" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/cluster.spec"
  content = "${data.template_file.cluster_spec.rendered}"
}
