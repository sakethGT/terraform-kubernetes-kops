output "masters_instance_profile" {
  value       = aws_iam_role.masters.arn
  description = "The ARN for the masters instance profile"
}

output "nodes_instance_profile" {
  value       = aws_iam_role.nodes.name
  description = "The name of the nodes IAM role"
}

output "nodes_instance_profile_arn" {
  value       = aws_iam_role.nodes.arn
  description = "The ARN for the nodes instance profile"
}

output "nodes_security_group_id" {
  value       = aws_security_group.nodes.id
  description = "The security group ID of the Kubernetes worker nodes"
}

output "api_dns_name" {
  value       = aws_elb.api_masters.dns_name
  description = "The DNS name for the masters API server ELB"
}

output "api_username" {
  value       = "admin"
  description = "The username used to communicate with the API"
}

output "api_password" {
  value     = random_string.token[index(local.tokens, "kube")].result
  sensitive = true
}
