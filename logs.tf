resource "aws_cloudwatch_log_group" "k8s_log_group" {
  name              = "/${var.project_name}/k8s/${var.env}"
  retention_in_days = "180"

  tags {
    Project     = "${var.project_name}"
    Environment = "${var.env}"
    Terraformed = "true"
    cost_center = "${var.cost_center}"
  }
}

resource "aws_cloudwatch_log_subscription_filter" "k8s_filter" {
  name            = "${var.project_name}_${var.env}"
  role_arn        = "${var.kinesis_stream_cloudwatch_log_role_arn}"
  log_group_name  = "${aws_cloudwatch_log_group.k8s_log_group.name}"
  filter_pattern  = "${var.kinesis_stream_filter_pattern}"
  destination_arn = "${var.kinesis_stream_cloudwatch_log_arn}"
}
