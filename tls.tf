# TLS certificate infrastructure for all Kubernetes components.
# Generates a full PKI hierarchy: CA certs, component certs for kube-apiserver,
# kubelet, kube-proxy, kube-scheduler, kube-controller-manager, and the
# apiserver-aggregator chain. All certs and keys are stored in S3 for kops
# node bootstrapping via nodeup.

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
    module.tls_kops.cert_pem,
    module.tls_kube-controller-manager.cert_pem,
    module.tls_kube-proxy.cert_pem,
    module.tls_kube-scheduler.cert_pem,
    module.tls_kubecfg.cert_pem,
    module.tls_kubelet-api.cert_pem,
    module.tls_kubelet.cert_pem,
    module.tls_master.cert_pem,
    module.tls_apiserver-proxy-client.cert_pem,
  ]

  tls_keys = [
    module.tls_kops.private_key_pem,
    module.tls_kube-controller-manager.private_key_pem,
    module.tls_kube-proxy.private_key_pem,
    module.tls_kube-scheduler.private_key_pem,
    module.tls_kubecfg.private_key_pem,
    module.tls_kubelet-api.private_key_pem,
    module.tls_kubelet.private_key_pem,
    module.tls_master.private_key_pem,
    module.tls_apiserver-proxy-client.private_key_pem,
  ]
}

module "tls_apiserver_aggregator_ca" {
  source = "../tls"

  is_ca_certificate     = true
  ca_common_name        = "apiserver-aggregator-ca"
  organization_name     = "Kubernetes"
  validity_period_hours = "8600h"
}

module "tls_apiserver_aggregator" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = module.tls_apiserver_aggregator_ca.ca_private_key_pem
  ca_cert_pem        = module.tls_apiserver_aggregator_ca.ca_cert_pem
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
  organization_name     = "Kubernetes"
  validity_period_hours = "8600h"
}

module "tls_master" {
  source = "../tls"

  is_ca_certificate  = false
  ca_private_key_pem = module.tls_kubernetes_ca.ca_private_key_pem
  ca_cert_pem        = module.tls_kubernetes_ca.ca_cert_pem
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
  ca_private_key_pem = module.tls_kubernetes_ca.ca_private_key_pem
  ca_cert_pem        = module.tls_kubernetes_ca.ca_cert_pem
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
  ca_private_key_pem = module.tls_kubernetes_ca.ca_private_key_pem
  ca_cert_pem        = module.tls_kubernetes_ca.ca_cert_pem
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
  ca_private_key_pem = module.tls_kubernetes_ca.ca_private_key_pem
  ca_cert_pem        = module.tls_kubernetes_ca.ca_cert_pem
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
  ca_private_key_pem = module.tls_kubernetes_ca.ca_private_key_pem
  ca_cert_pem        = module.tls_kubernetes_ca.ca_cert_pem
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
  ca_private_key_pem = module.tls_kubernetes_ca.ca_private_key_pem
  ca_cert_pem        = module.tls_kubernetes_ca.ca_cert_pem
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
  ca_private_key_pem = module.tls_kubernetes_ca.ca_private_key_pem
  ca_cert_pem        = module.tls_kubernetes_ca.ca_cert_pem
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
  ca_private_key_pem = module.tls_kubernetes_ca.ca_private_key_pem
  ca_cert_pem        = module.tls_kubernetes_ca.ca_cert_pem
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
  ca_private_key_pem = module.tls_kubernetes_ca.ca_private_key_pem
  ca_cert_pem        = module.tls_kubernetes_ca.ca_cert_pem
  common_name        = "kube-controller-manager"
  organization_name  = "system:masters"

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "client_auth",
  ]
}

# Issued and private keysets for all TLS components, stored in S3

resource "aws_s3_object" "tls_apiserver_aggregator_issued_ca_keyset" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/issued/apiserver-aggregator-ca/keyset.yaml"
  content = templatefile("${path.module}/data/issued_keyset.tpl", {
    name = "apiserver-aggregator-ca"
    cert = base64encode(module.tls_apiserver_aggregator_ca.ca_cert_pem)
  })
}

resource "aws_s3_object" "tls_apiserver_aggregator_private_ca_keyset" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/private/apiserver-aggregator-ca/keyset.yaml"
  content = templatefile("${path.module}/data/private_keyset.tpl", {
    name = "apiserver-aggregator-ca"
    cert = base64encode(module.tls_apiserver_aggregator_ca.ca_cert_pem)
    key  = base64encode(module.tls_apiserver_aggregator_ca.ca_private_key_pem)
  })
}

resource "aws_s3_object" "tls_apiserver_aggregator_issued_ca_cert" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/issued/apiserver-aggregator-ca/1.crt"
  content = module.tls_apiserver_aggregator_ca.ca_cert_pem
}

resource "aws_s3_object" "tls_apiserver_aggregator_private_ca_key" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/private/apiserver-aggregator-ca/1.key"
  content = module.tls_apiserver_aggregator_ca.ca_private_key_pem
}

resource "aws_s3_object" "tls_apiserver_aggregator_issued_keyset" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/issued/apiserver-aggregator/keyset.yaml"
  content = templatefile("${path.module}/data/issued_keyset.tpl", {
    name = "apiserver-aggregator"
    cert = base64encode(module.tls_apiserver_aggregator.cert_pem)
  })
}

resource "aws_s3_object" "tls_apiserver_aggregator_private_keyset" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/private/apiserver-aggregator/keyset.yaml"
  content = templatefile("${path.module}/data/private_keyset.tpl", {
    name = "apiserver-aggregator"
    cert = base64encode(module.tls_apiserver_aggregator.cert_pem)
    key  = base64encode(module.tls_apiserver_aggregator.private_key_pem)
  })
}

resource "aws_s3_object" "tls_apiserver_aggregator_issued_cert" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/issued/apiserver-aggregator/1.crt"
  content = module.tls_apiserver_aggregator.cert_pem
}

resource "aws_s3_object" "tls_apiserver_aggregator_private_key" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/private/apiserver-aggregator/1.key"
  content = module.tls_apiserver_aggregator.private_key_pem
}

resource "aws_s3_object" "tls_kubernetes_issued_ca_keyset" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/issued/ca/keyset.yaml"
  content = templatefile("${path.module}/data/issued_keyset.tpl", {
    name = "ca"
    cert = base64encode(module.tls_kubernetes_ca.ca_cert_pem)
  })
}

resource "aws_s3_object" "tls_kubernetes_private_ca_keyset" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/private/ca/keyset.yaml"
  content = templatefile("${path.module}/data/private_keyset.tpl", {
    name = "ca"
    cert = base64encode(module.tls_kubernetes_ca.ca_cert_pem)
    key  = base64encode(module.tls_kubernetes_ca.ca_private_key_pem)
  })
}

resource "aws_s3_object" "tls_kubernetes_issued_ca_cert" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/issued/ca/1.crt"
  content = module.tls_kubernetes_ca.ca_cert_pem
}

resource "aws_s3_object" "tls_kubernetes_private_ca_key" {
  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/private/ca/1.key"
  content = module.tls_kubernetes_ca.ca_private_key_pem
}

resource "aws_s3_object" "tls_kubernetes_issued_components_keyset" {
  count = length(local.tls_components)

  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/issued/${local.tls_components[count.index]}/keyset.yaml"
  content = templatefile("${path.module}/data/issued_keyset.tpl", {
    name = local.tls_components[count.index]
    cert = base64encode(local.tls_certs[count.index])
  })
}

resource "aws_s3_object" "tls_kubernetes_private_components_keyset" {
  count = length(local.tls_components)

  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/private/${local.tls_components[count.index]}/keyset.yaml"
  content = templatefile("${path.module}/data/private_keyset.tpl", {
    name = local.tls_components[count.index]
    cert = base64encode(local.tls_certs[count.index])
    key  = base64encode(local.tls_keys[count.index])
  })
}

resource "aws_s3_object" "tls_kubernetes_issued_components_cert" {
  count = length(local.tls_components)

  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/issued/${local.tls_components[count.index]}/1.crt"
  content = local.tls_certs[count.index]
}

resource "aws_s3_object" "tls_kubernetes_private_components_key" {
  count = length(local.tls_components)

  bucket  = var.config_bucket
  key     = "${var.cluster_name}/pki/private/${local.tls_components[count.index]}/1.key"
  content = local.tls_keys[count.index]
}
