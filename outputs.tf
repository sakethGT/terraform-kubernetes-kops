output "masters_instance_profile" {
  value       = "${aws_iam_role.masters.arn}"
  description = "This is the ARN for the masters instance profile"
}

output "nodes_instance_profile" {
  value       = "${aws_iam_role.nodes.name}"
  description = "This is the ARN for the nodes instance profile"
}

output "nodes_instance_profile_arn" {
  value       = "${aws_iam_role.nodes.arn}"
  description = "This is the ARN for the nodes instance profile"
}

output "nodes_security_group_id" {
  value       = "${aws_security_group.nodes.id}"
  description = "The SG-id of the Kubernetes Ndoes"
}

output "api_dns_name" {
  value       = "${aws_elb.api_masters.dns_name}"
  description = "The DNS name for Masters API server"
}

output "api_username" {
  value       = "admin"
  description = "The Username used to communicate with the API"
}

output "api_password" {
  value = "${element(random_string.token.*.result, index(local.tokens, "kube"))}"
}
