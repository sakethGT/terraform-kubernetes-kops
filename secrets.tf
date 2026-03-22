# Kubernetes component authentication tokens stored in S3.
# Each component (kubelet, kube-proxy, scheduler, etc.) gets a unique token
# for API server authentication.

locals {
  tokens = [
    "admin",
    "kube",
    "kube-proxy",
    "kubelet",
    "system:controller_manager",
    "system:dns",
    "system:logging",
    "system:monitoring",
    "system:scheduler",
  ]
}

resource "random_string" "token" {
  count = length(local.tokens)

  length  = 32
  special = false
}

resource "aws_s3_object" "secrets" {
  count = length(local.tokens)

  bucket  = var.config_bucket
  key     = "${var.cluster_name}/secrets/${local.tokens[count.index]}"
  content = templatefile("${path.module}/data/secrets.tpl", {
    token = base64encode(random_string.token[count.index].result)
  })
}
