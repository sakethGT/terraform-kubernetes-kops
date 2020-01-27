locals {
  tls_components = [
    "kops",
    "kube-controller-manager",
    "kube-proxy",
    "kube-scheduler",
    "kubecfg",
    "kubelet-api",
    "kubelet",
    "master",
    "apiserver-proxy-client",
  ]

  tls_certs = [
    "${module.tls_kops.cert_pem}",
    "${module.tls_kube-controller-manager.cert_pem}",
    "${module.tls_kube-proxy.cert_pem}",
    "${module.tls_kube-scheduler.cert_pem}",
    "${module.tls_kubecfg.cert_pem}",
    "${module.tls_kubelet-api.cert_pem}",
    "${module.tls_kubelet.cert_pem}",
    "${module.tls_master.cert_pem}",
    "${module.tls_apiserver-proxy-client.cert_pem}",
  ]

  tls_keys = [
    "${module.tls_kops.private_key_pem}",
    "${module.tls_kube-controller-manager.private_key_pem}",
    "${module.tls_kube-proxy.private_key_pem}",
    "${module.tls_kube-scheduler.private_key_pem}",
    "${module.tls_kubecfg.private_key_pem}",
    "${module.tls_kubelet-api.private_key_pem}",
    "${module.tls_kubelet.private_key_pem}",
    "${module.tls_master.private_key_pem}",
    "${module.tls_apiserver-proxy-client.private_key_pem}",
  ]
}

module "tls_apiserver_aggregator_ca" {
  source = "../tls"

  is_ca_certificate     = true
  ca_common_name        = "apiserver-aggregator-ca"
  organization_name     = "Connected Platform Services"
  validity_period_hours = "8600h"
}

module "tls_apiserver_aggregator" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = "${module.tls_apiserver_aggregator_ca.ca_private_key_pem}"
  ca_cert_pem        = "${module.tls_apiserver_aggregator_ca.ca_cert_pem}"
  common_name        = "aggregator"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "client_auth",
  ]
}

module "tls_kubernetes_ca" {
  source = "../tls"

  is_ca_certificate     = true
  ca_common_name        = "kubernetes"
  organization_name     = "Connected Platform Services"
  validity_period_hours = "8600h"
}

module "tls_master" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = "${module.tls_kubernetes_ca.ca_private_key_pem}"
  ca_cert_pem        = "${module.tls_kubernetes_ca.ca_cert_pem}"
  common_name        = "master"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "server_auth",
  ]

  dns_names = [
    "api.${var.cluster_name}",
    "api.internal.${var.cluster_name}",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster.local",
  ]

  ip_addresses = [
    "100.64.0.1",
    "127.0.0.1",
  ]
}

module "tls_apiserver-proxy-client" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = "${module.tls_kubernetes_ca.ca_private_key_pem}"
  ca_cert_pem        = "${module.tls_kubernetes_ca.ca_cert_pem}"
  common_name        = "apiserver-proxy-client"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "client_auth",
  ]
}

module "tls_kubelet" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = "${module.tls_kubernetes_ca.ca_private_key_pem}"
  ca_cert_pem        = "${module.tls_kubernetes_ca.ca_cert_pem}"
  common_name        = "kubelet"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "client_auth",
  ]
}

module "tls_kubelet-api" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = "${module.tls_kubernetes_ca.ca_private_key_pem}"
  ca_cert_pem        = "${module.tls_kubernetes_ca.ca_cert_pem}"
  common_name        = "kubelet-api"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "client_auth",
  ]
}

module "tls_kubecfg" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = "${module.tls_kubernetes_ca.ca_private_key_pem}"
  ca_cert_pem        = "${module.tls_kubernetes_ca.ca_cert_pem}"
  common_name        = "kubecfg"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "client_auth",
  ]
}

module "tls_kube-scheduler" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = "${module.tls_kubernetes_ca.ca_private_key_pem}"
  ca_cert_pem        = "${module.tls_kubernetes_ca.ca_cert_pem}"
  common_name        = "kube-scheduler"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "client_auth",
  ]
}

module "tls_kube-proxy" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = "${module.tls_kubernetes_ca.ca_private_key_pem}"
  ca_cert_pem        = "${module.tls_kubernetes_ca.ca_cert_pem}"
  common_name        = "kube-proxy"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "client_auth",
  ]
}

module "tls_kops" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = "${module.tls_kubernetes_ca.ca_private_key_pem}"
  ca_cert_pem        = "${module.tls_kubernetes_ca.ca_cert_pem}"
  common_name        = "kops"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "client_auth",
  ]
}

module "tls_kube-controller-manager" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = "${module.tls_kubernetes_ca.ca_private_key_pem}"
  ca_cert_pem        = "${module.tls_kubernetes_ca.ca_cert_pem}"
  common_name        = "kube-controller-manager"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "client_auth",
  ]
}

data "template_file" "tls_kubernetes_issued_components_keyset" {
  count = "${length(local.tls_components)}"

  template = "${file("${path.module}/data/issued_keyset.tpl")}"

  vars {
    name = "${element(local.tls_components, count.index)}"
    cert = "${base64encode(element(local.tls_certs, count.index))}"
  }
}

data "template_file" "tls_kubernetes_private_components_keyset" {
  count = "${length(local.tls_components)}"

  template = "${file("${path.module}/data/private_keyset.tpl")}"

  vars {
    name = "${element(local.tls_components, count.index)}"
    cert = "${base64encode(element(local.tls_certs, count.index))}"
    key  = "${base64encode(element(local.tls_keys, count.index))}"
  }
}

data "template_file" "tls_apiserver_aggregator_issued_ca_keyset" {
  template = "${file("${path.module}/data/issued_keyset.tpl")}"

  vars {
    name = "apiserver-aggregator-ca"
    cert = "${base64encode(module.tls_apiserver_aggregator_ca.ca_cert_pem)}"
  }
}

data "template_file" "tls_apiserver_aggregator_private_ca_keyset" {
  template = "${file("${path.module}/data/private_keyset.tpl")}"

  vars {
    name = "apiserver-aggregator-ca"
    cert = "${base64encode(module.tls_apiserver_aggregator_ca.ca_cert_pem)}"
    key  = "${base64encode(module.tls_apiserver_aggregator_ca.ca_private_key_pem)}"
  }
}

data "template_file" "tls_apiserver_aggregator_issued_keyset" {
  template = "${file("${path.module}/data/issued_keyset.tpl")}"

  vars {
    name = "apiserver-aggregator"
    cert = "${base64encode(module.tls_apiserver_aggregator.cert_pem)}"
  }
}

data "template_file" "tls_apiserver_aggregator_private_keyset" {
  template = "${file("${path.module}/data/private_keyset.tpl")}"

  vars {
    name = "apiserver-aggregator"
    cert = "${base64encode(module.tls_apiserver_aggregator.cert_pem)}"
    key  = "${base64encode(module.tls_apiserver_aggregator.private_key_pem)}"
  }
}

data "template_file" "tls_kubernetes_issued_ca_keyset" {
  template = "${file("${path.module}/data/issued_keyset.tpl")}"

  vars {
    name = "ca"
    cert = "${base64encode(module.tls_kubernetes_ca.ca_cert_pem)}"
  }
}

data "template_file" "tls_kubernetes_private_ca_keyset" {
  template = "${file("${path.module}/data/private_keyset.tpl")}"

  vars {
    name = "ca"
    cert = "${base64encode(module.tls_kubernetes_ca.ca_cert_pem)}"
    key  = "${base64encode(module.tls_kubernetes_ca.ca_private_key_pem)}"
  }
}

resource "aws_s3_bucket_object" "tls_apiserver_aggregator_issued_ca_keyset" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/issued/apiserver-aggregator-ca/keyset.yaml"
  content = "${data.template_file.tls_apiserver_aggregator_issued_ca_keyset.rendered}"
}

resource "aws_s3_bucket_object" "tls_apiserver_aggregator_private_ca_keyset" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/private/apiserver-aggregator-ca/keyset.yaml"
  content = "${data.template_file.tls_apiserver_aggregator_private_ca_keyset.rendered}"
}

resource "aws_s3_bucket_object" "tls_apiserver_aggregator_issued_ca_cert" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/issued/apiserver-aggregator-ca/1.crt"
  content = "${module.tls_apiserver_aggregator_ca.ca_cert_pem}"
}

resource "aws_s3_bucket_object" "tls_apiserver_aggregator_private_ca_key" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/private/apisever-aggregator-ca/1.key"
  content = "${module.tls_apiserver_aggregator_ca.ca_private_key_pem}"
}

resource "aws_s3_bucket_object" "tls_apiserver_aggregator_issued_keyset" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/issued/apiserver-aggregator/keyset.yaml"
  content = "${data.template_file.tls_apiserver_aggregator_issued_keyset.rendered}"
}

resource "aws_s3_bucket_object" "tls_apiserver_aggregator_private_keyset" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/private/apiserver-aggregator/keyset.yaml"
  content = "${data.template_file.tls_apiserver_aggregator_private_keyset.rendered}"
}

resource "aws_s3_bucket_object" "tls_apiserver_aggregator_issued_cert" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/issued/apiserver-aggregator/1.crt"
  content = "${module.tls_apiserver_aggregator.cert_pem}"
}

resource "aws_s3_bucket_object" "tls_apiserver_aggregator_private_key" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/private/apisever-aggregator/1.key"
  content = "${module.tls_apiserver_aggregator.private_key_pem}"
}

resource "aws_s3_bucket_object" "tls_kubernetes_issued_ca_keyset" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/issued/ca/keyset.yaml"
  content = "${data.template_file.tls_kubernetes_issued_ca_keyset.rendered}"
}

resource "aws_s3_bucket_object" "tls_kubernetes_private_ca_keyset" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/private/ca/keyset.yaml"
  content = "${data.template_file.tls_kubernetes_private_ca_keyset.rendered}"
}

resource "aws_s3_bucket_object" "tls_kubernetes_issued_ca_cert" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/issued/ca/1.crt"
  content = "${module.tls_kubernetes_ca.ca_cert_pem}"
}

resource "aws_s3_bucket_object" "tls_kubernetes_private_ca_key" {
  bucket  = "${var.config_bucket}"
  key     = "${var.cluster_name}/pki/private/ca/1.key"
  content = "${module.tls_kubernetes_ca.ca_private_key_pem}"
}

resource "aws_s3_bucket_object" "tls_kubernetes_issued_components_keyset" {
  count = "${length(local.tls_components)}"

  bucket  = "${var.config_bucket}"
  key     = "${format("%s/pki/issued/%s/keyset.yaml", var.cluster_name, element(local.tls_components, count.index))}"
  content = "${element(data.template_file.tls_kubernetes_issued_components_keyset.*.rendered, count.index)}"
}

resource "aws_s3_bucket_object" "tls_kubernetes_private_components_keyset" {
  count = "${length(local.tls_components)}"

  bucket  = "${var.config_bucket}"
  key     = "${format("%s/pki/private/%s/keyset.yaml", var.cluster_name, element(local.tls_components, count.index))}"
  content = "${element(data.template_file.tls_kubernetes_private_components_keyset.*.rendered, count.index)}"
}

resource "aws_s3_bucket_object" "tls_kubernetes_issued_components_cert" {
  count = "${length(local.tls_components)}"

  bucket  = "${var.config_bucket}"
  key     = "${format("%s/pki/issued/%s/1.crt", var.cluster_name, element(local.tls_components, count.index))}"
  content = "${element(local.tls_certs, count.index)}"
}

resource "aws_s3_bucket_object" "tls_kubernetes_private_components_key" {
  count = "${length(local.tls_components)}"

  bucket  = "${var.config_bucket}"
  key     = "${format("%s/pki/private/%s/1.key", var.cluster_name, element(local.tls_components, count.index))}"
  content = "${element(local.tls_keys, count.index)}"
}
