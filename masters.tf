resource "aws_autoscaling_attachment" "masters_us_east" {
  count = 3

  elb                    = "${aws_elb.api_masters.id}"
  autoscaling_group_name = "${element(aws_autoscaling_group.masters_us_east.*.id, count.index)}"
}

resource "aws_elb" "api_masters" {
  name = "api-${replace(var.cluster_name,".","-")}"

  listener = {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }

  security_groups = ["${aws_security_group.api_elb.id}", "${aws_security_group.api_elb_ci.id}"]
  subnets         = ["${var.masters_public_subnets}"]

  health_check = {
    target              = "SSL:443"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5
  }

  idle_timeout = 300

  tags = {
    KubernetesCluster = "${var.cluster_name}"
    Name              = "api.${var.cluster_name}"
    Terraformed       = true
    Environment       = "${var.env}"
    cost_center       = "${var.cost_center}"
  }
}

resource "aws_autoscaling_group" "masters_us_east" {
  count                = 3
  name                 = "${var.project_name}-${var.env}-k8s-master-${element(var.masters_availability_zones, count.index)}"
  launch_configuration = "${element(aws_launch_configuration.masters.*.id, count.index)}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${element(var.masters_private_subnet_ids, count.index)}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  tag = {
    key                 = "\"kubernetes.io/cluster/${var.cluster_name}\""
    value               = "shared"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "${var.project_name}-k8s-master-${element(var.masters_availability_zones, count.index)}"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_launch_configuration" "masters" {
  count = 3

  name_prefix                 = "${var.project_name}-${var.env}-k8s-master-${element(var.masters_availability_zones, count.index)}"
  image_id                    = "${data.aws_ami.coreos_ami.image_id}"
  instance_type               = "${var.masters_instance_type}"
  key_name                    = "${var.masters_ssh_key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters.id}"
  security_groups             = ["${aws_security_group.masters.id}"]
  user_data                   = "${element(data.ignition_config.masters.*.rendered, count.index)}"
  associate_public_ip_address = false

  root_block_device = {
    volume_type           = "${var.masters_root_volume_type}"
    volume_size           = "${var.masters_root_volume_size}"
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

data "ignition_config" "masters" {
  count = 3

  systemd = [
    "${data.ignition_systemd_unit.docker_dropin.id}",
    "${data.ignition_systemd_unit.node_up.id}",
    "${data.ignition_systemd_unit.locksmithd.id}",
    "${data.ignition_systemd_unit.update_engine.id}",
  ]

  files = [
    "${data.ignition_file.updates.id}",
    "${data.ignition_file.docker_1_12.id}",
    "${data.ignition_file.masters_cluster_spec.id}",
    "${data.ignition_file.node_up.id}",
    "${element(data.ignition_file.masters_kube_env.*.id, count.index)}",
    "${element(data.ignition_file.masters_ig_spec.*.id, count.index)}",
  ]
}
