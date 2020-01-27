resource "aws_autoscaling_group" "nodes" {
  name                 = "${var.project_name}-${var.env}-k8s-nodes.${var.cluster_name}"
  launch_configuration = "${aws_launch_configuration.nodes.id}"
  max_size             = "${var.nodes_asg_max_size}"
  min_size             = "${var.nodes_asg_min_size}"
  vpc_zone_identifier  = ["${var.nodes_private_subnet_ids}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.${var.cluster_name}"
    propagate_at_launch = true
  }

  tag = {
    key                 = "\"kubernetes.io/cluster/${var.cluster_name}\""
    value               = "shared"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "yes"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_launch_configuration" "nodes" {
  name_prefix                 = "${var.project_name}-${var.env}-k8s-nodes-"
  image_id                    = "${data.aws_ami.coreos_ami.image_id}"
  instance_type               = "${var.nodes_instance_type}"
  key_name                    = "${var.nodes_ssh_key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes.id}"
  security_groups             = ["${aws_security_group.nodes.id}"]
  associate_public_ip_address = false
  user_data                   = "${data.ignition_config.nodes.rendered}"

  root_block_device = {
    volume_type           = "${var.nodes_root_volume_type}"
    volume_size           = "${var.nodes_root_volume_size}"
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

data "ignition_config" "nodes" {
  systemd = [
    "${data.ignition_systemd_unit.docker_dropin.id}",
    "${data.ignition_systemd_unit.node_up.id}",
    "${data.ignition_systemd_unit.locksmithd.id}",
    "${data.ignition_systemd_unit.update_engine.id}",
  ]

  files = [
    "${data.ignition_file.updates.id}",
    "${data.ignition_file.docker_1_12.id}",
    "${data.ignition_file.nodes_cluster_spec.id}",
    "${data.ignition_file.nodes_ig_spec.id}",
    "${data.ignition_file.nodes_kube_env.id}",
    "${data.ignition_file.node_up.id}",
  ]
}
