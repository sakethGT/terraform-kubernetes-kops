locals {
  install_dir = "/var/lib/toolbox/kubernetes-install"
}

data "ignition_systemd_unit" "docker_dropin" {
  name    = "docker.service"
  enabled = true

  dropin {
    name    = "10dockeropts.conf"
    content = "[Service]\nEnvironment=\"DOCKER_OPTS=--bip 192.169.0.1/16 --dns 169.254.169.253\""
  }
}

data "ignition_file" "docker_1_12" {
  path       = "/etc/coreos/docker-1.12"
  filesystem = "root"

  content {
    content = "yes"
  }
}

data "ignition_file" "updates" {
  path       = "/etc/coreos/update.conf"
  filesystem = "root"
  mode       = "420"

  content {
    content = "REBOOT_STRATEGY: off"
  }
}

data "template_file" "masters_ig_spec" {
  count    = 3
  template = "${file("${path.module}/data/masters_ig_spec.tpl")}"

  vars {
    az_id = "${substr(element(var.masters_availability_zones, count.index), -1, 1)}"
  }
}

data "ignition_file" "masters_ig_spec" {
  count = 3

  path       = "${local.install_dir}/ig_spec.yaml"
  filesystem = "root"
  mode       = "600"

  content {
    content = "${element(data.template_file.masters_ig_spec.*.rendered, count.index)}"
  }
}

data "template_file" "masters_kube_env" {
  count    = 3
  template = "${file("${path.module}/data/masters_kube_env.tpl")}"

  vars {
    az_id         = "${substr(element(var.masters_availability_zones, count.index), -1, 1)}"
    config_bucket = "${var.config_bucket}"
    cluster_name  = "${var.cluster_name}"
  }
}

data "ignition_file" "masters_kube_env" {
  count = 3

  path       = "${local.install_dir}/kube_env.yaml"
  filesystem = "root"
  mode       = "600"

  content {
    content = "${element(data.template_file.masters_kube_env.*.rendered, count.index)}"
  }
}

data "ignition_file" "masters_cluster_spec" {
  path       = "${local.install_dir}/cluster_spec.yaml"
  filesystem = "root"
  mode       = "600"

  content {
    content = "${file("${path.module}/data/masters_cluster_spec.tpl")}"
  }
}

data "ignition_file" "nodes_cluster_spec" {
  path       = "${local.install_dir}/cluster_spec.yaml"
  filesystem = "root"
  mode       = "600"

  content {
    content = "${file("${path.module}/data/nodes_cluster_spec.tpl")}"
  }
}

data "template_file" "nodes_kube_env" {
  template = "${file("${path.module}/data/nodes_kube_env.tpl")}"

  vars {
    config_bucket = "${var.config_bucket}"
    cluster_name  = "${var.cluster_name}"
  }
}

data "ignition_file" "nodes_kube_env" {
  path       = "${local.install_dir}/kube_env.yaml"
  filesystem = "root"
  mode       = "600"

  content {
    content = "${data.template_file.nodes_kube_env.rendered}"
  }
}

data "ignition_file" "nodes_ig_spec" {
  path       = "${local.install_dir}/ig_spec.yaml"
  filesystem = "root"
  mode       = "600"

  content {
    content = "${file("${path.module}/data/nodes_ig_spec.tpl")}"
  }
}

data "ignition_file" "node_up" {
  path       = "${local.install_dir}/nodeup"
  filesystem = "root"
  mode       = "700"

  source {
    source       = "https://kubeupv2.s3.amazonaws.com/kops/1.9.0/linux/amd64/nodeup"
    verification = "sha512-9c40cdcc6857a5d5c053bf99648b8d78817a4f03533daecb2feed0d56f6d40e237f225708cf33dd4491c4e2fc7b4e498d86aafed22378e06272e12026bb7810d"
  }
}

data "ignition_systemd_unit" "node_up" {
  name    = "nodeup.service"
  content = "[Unit]\nConditionPathExists=${local.install_dir}/nodeup\n[Service]\nType=oneshot\nExecStart=${local.install_dir}/nodeup --install-systemd-unit --conf=${local.install_dir}/kube_env.yaml --v=8\n[Install]\nWantedBy=multi-user.target"
}

data "ignition_systemd_unit" "update_engine" {
  name = "update-engine.service"
  mask = true
}

data "ignition_systemd_unit" "locksmithd" {
  name = "locksmithd.service"
  mask = true
}
