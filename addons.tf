locals {
  files = [
    "bootstrap-channel.yaml",
    "core.addons.k8s.io/v1.4.0.yaml",
    "dns-controller.addons.k8s.io/k8s-1.6.yaml",
    "kube-dns.addons.k8s.io/k8s-1.6.yaml",
    "limit-range.addons.k8s.io/v1.5.0.yaml",
    "networking.flannel/k8s-1.6.yaml",
    "rbac.addons.k8s.io/k8s-1.8.yaml",
    "storage-aws.addons.k8s.io/v1.6.0.yaml",
    "storage-aws.addons.k8s.io/v1.7.0.yaml",
    "kube-state-metrics.addons.k8s.io/k8s-1.9.yaml",
    "dashboard.addons.k8s.io/k8s-1.9.yaml",
    "heapster.addons.k8s.io/k8s-1.9.yaml",
    "autoscaler.k8s.io/k8s-1.9.yaml",
  ]
}

resource "aws_s3_bucket_object" "addons" {
  count = "${length(local.files)}"

  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/addons/${element(local.files, count.index)}"
  content = "${file("${path.module}/addons/${element(local.files, count.index)}")}"
}

data "template_file" "kube2iam" {
  template = "${file("${path.module}/addons/kube2iam.addons.k8s.io/k8s-1.9.yaml")}"

  vars {
    aws_account_id = "${data.aws_caller_identity.current.account_id}"
    role           = "nodes.${var.cluster_name}"
  }
}

resource "aws_s3_bucket_object" "addons_kube2iam" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/addons/kube2iam.addons.k8s.io/k8s-1.9.yaml"
  content = "${data.template_file.kube2iam.rendered}"
}
