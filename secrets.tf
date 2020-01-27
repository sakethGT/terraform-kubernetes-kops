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
  count = "${length(local.tokens)}"

  length  = 32
  special = false
}

data "template_file" "tokens" {
  count    = "${length(local.tokens)}"
  template = "${file("${path.module}/data/secrets.tpl")}"

  vars = {
    token = "${base64encode(element(random_string.token.*.result, count.index))}"
  }
}

resource "aws_s3_bucket_object" "secrets" {
  count = "${length(local.tokens)}"

  bucket  = "${var.config_bucket}"
  key     = "${format("%s/secrets/%s", var.cluster_name, element(local.tokens, count.index))}"
  content = "${element(data.template_file.tokens.*.rendered, count.index)}"
}
