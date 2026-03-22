# Kubernetes add-ons stored in S3 and bootstrapped via the kops addon manager.
# Includes: DNS, flannel networking, dashboard, cluster autoscaler,
# kube-state-metrics, heapster, kube2iam, RBAC, and storage classes.

locals {
  addon_files = [
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

resource "aws_s3_object" "addons" {
  count = length(local.addon_files)

  bucket  = var.config_bucket
  key     = "${var.cluster_name}/addons/${local.addon_files[count.index]}"
  content = file("${path.module}/addons/${local.addon_files[count.index]}")
}

resource "aws_s3_object" "addons_kube2iam" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/addons/kube2iam.addons.k8s.io/k8s-1.9.yaml"
  content = templatefile("${path.module}/addons/kube2iam.addons.k8s.io/k8s-1.9.yaml", {
    aws_account_id = data.aws_caller_identity.current.account_id
    role           = "nodes.${var.cluster_name}"
  })
}
