resource "aws_security_group" "nodes" {
  name        = "nodes.${var.cluster_name}"
  description = "Kubernetes Nodes security group"
  vpc_id      = "${var.vpc_id}"

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "nodes.${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    cost_center                                 = "${var.cost_center}"
  }
}

resource "aws_security_group" "api_elb_ci" {
  name        = "api-elb-ci.${var.cluster_name}"
  vpc_id      = "${var.vpc_id}"
  description = "Security group for api ELB for CI connection"

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "api-elb-ci.${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    cost_center                                 = "${var.cost_center}"
  }
}

resource "aws_security_group" "api_elb" {
  name        = "api-elb.${var.cluster_name}"
  vpc_id      = "${var.vpc_id}"
  description = "Security group for api ELB"

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "api-elb.${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    cost_center                                 = "${var.cost_center}"
  }
}

resource "aws_security_group" "masters" {
  name        = "masters.${var.cluster_name}"
  vpc_id      = "${var.vpc_id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "masters.${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    cost_center                                 = "${var.cost_center}"
  }
}

resource "aws_security_group_rule" "all_master_to_master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters.id}"
  source_security_group_id = "${aws_security_group.masters.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all_master_to_node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes.id}"
  source_security_group_id = "${aws_security_group.masters.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all_node_to_node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes.id}"
  source_security_group_id = "${aws_security_group.nodes.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "api_elb_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.api_elb.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_api_elb" {
  type              = "ingress"
  security_group_id = "${aws_security_group.api_elb.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${var.allowed_ips}"]
}

resource "aws_security_group_rule" "https_ci_api_elb" {
  type              = "ingress"
  security_group_id = "${aws_security_group.api_elb_ci.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${var.ci_allowed_ips}"]
}

resource "aws_security_group_rule" "https_elb_to_master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters.id}"
  source_security_group_id = "${aws_security_group.api_elb.id}"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "master_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node_to_master_tcp_1_2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters.id}"
  source_security_group_id = "${aws_security_group.nodes.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node_to_master_tcp_2382_4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters.id}"
  source_security_group_id = "${aws_security_group.nodes.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node_to_master_tcp_4003_65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters.id}"
  source_security_group_id = "${aws_security_group.nodes.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node_to_master_udp_1_65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters.id}"
  source_security_group_id = "${aws_security_group.nodes.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}
