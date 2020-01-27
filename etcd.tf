resource "aws_ebs_volume" "etcd_events" {
  count = 3

  availability_zone = "${element(var.masters_availability_zones, count.index)}"
  size              = "${var.etcd_events_ebs_size}"
  type              = "${var.etcd_events_ebs_type}"
  encrypted         = "${var.etcd_events_encrypted}"

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "${substr(element(var.masters_availability_zones, count.index), -1, 1)}.etcd-events.${var.cluster_name}"
    "k8s.io/etcd/events"                        = "${substr(element(var.masters_availability_zones, count.index), -1, 1)}/${substr(var.masters_availability_zones[0], -1,1)},${substr(var.masters_availability_zones[1], -1,1)},${substr(var.masters_availability_zones[2], -1,1)}"
    "k8s.io/role/master"                        = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = "${var.env}"
    Terraformed                                 = "true"
    cost_center                                 = "${var.cost_center}"
  }
}

resource "aws_ebs_volume" "etcd_main" {
  count = 3

  availability_zone = "${element(var.masters_availability_zones, count.index)}"
  size              = "${var.etcd_main_ebs_size}"
  type              = "${var.etcd_main_ebs_type}"
  encrypted         = "${var.etcd_main_encrypted}"

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "${substr(element(var.masters_availability_zones, count.index), -1, 1)}.etcd-main.${var.cluster_name}"
    "k8s.io/etcd/main"                          = "${substr(element(var.masters_availability_zones, count.index), -1, 1)}/${substr(var.masters_availability_zones[0], -1,1)},${substr(var.masters_availability_zones[1], -1,1)},${substr(var.masters_availability_zones[2], -1,1)}"
    "k8s.io/role/master"                        = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = "${var.env}"
    Terraformed                                 = "true"
    cost_center                                 = "${var.cost_center}"
  }
}
