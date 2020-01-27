variable "kinesis_stream_cloudwatch_log_arn" {
  type        = "string"
  description = ""
}

variable "kinesis_stream_cloudwatch_log_role_arn" {
  type        = "string"
  description = ""
}

variable "kinesis_stream_filter_pattern" {
  type        = "string"
  description = "A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events."
  default     = "[]"
}

variable "cluster_name" {
  type        = "string"
  description = "The KubernetesCluster name"
}

variable "vpc_id" {
  type        = "string"
  description = "The VpcId in which Kubernetes will live"
}

variable "etcd_events_ebs_size" {
  type        = "string"
  description = "The EBS Volume size for etcd-events. Defaults to 100GB"
  default     = "100"
}

variable "etcd_events_ebs_type" {
  type        = "string"
  description = "The EBS Volume type for etcd-events. Defaults to gp2"
  default     = "gp2"
}

variable "etcd_events_encrypted" {
  type        = "string"
  description = "Boolean to enabled encrypted EBS volumes for etcd-events. Defaults to false"
  default     = "false"
}

variable "etcd_main_ebs_size" {
  type        = "string"
  description = "The EBS Volume size for etcd-main. Defaults to 100GB"
  default     = "100"
}

variable "etcd_main_ebs_type" {
  type        = "string"
  description = "The EBS Volume type for etcd-main. Defaults to gp2"
  default     = "gp2"
}

variable "etcd_main_encrypted" {
  type        = "string"
  description = "Boolean to enabled encrypted EBS volumes for etcd-main. Defaults to false"
  default     = "false"
}

variable "masters_availability_zones" {
  type        = "list"
  description = "The list of availability zones to launch masters in"
}

variable "env" {
  type        = "string"
  description = "The environment name"
}

variable "nodes_root_volume_type" {
  type        = "string"
  description = "The root volume EBS volume type. Defaults to gp2"
  default     = "gp2"
}

variable "nodes_root_volume_size" {
  type        = "string"
  description = "The root volume EBS volume size. Defaults to 100GB"
  default     = "100"
}

variable "project_name" {
  type        = "string"
  description = "The project name"
}

variable "nodes_ssh_key_name" {
  type        = "string"
  description = "The ssh-key name to associate with nodes instances"
}

variable "masters_private_subnet_ids" {
  type        = "list"
  description = "List of subnet_ids the masters will use"
}

variable "config_bucket" {
  type        = "string"
  description = "The S3 storage bucket used for configurations"
}

variable "nodes_asg_max_size" {
  type        = "string"
  description = "The MAX_SIZE set for nodes AutoScalingGroup. Defaults to 5"
  default     = "5"
}

variable "nodes_asg_min_size" {
  type        = "string"
  description = "The MIN_SIZE set for nodes AutoScalingGroup. Defaults to 5"
  default     = "5"
}

variable "nodes_private_subnet_ids" {
  type        = "list"
  description = "The list of subnet_ids nodes can use"
}

variable "masters_ssh_key_name" {
  type        = "string"
  description = "The ssh-key name to use for masters instances"
}

variable "masters_instance_type" {
  type        = "string"
  description = "The instance type used for master instance"
}

variable "masters_root_volume_size" {
  type        = "string"
  description = "The EBS volume size for masters. Defaults to 100GB"
  default     = "100"
}

variable "masters_root_volume_type" {
  type        = "string"
  description = "The EBS volume type for masters. Dfaults to gp2"
  default     = "gp2"
}

variable "masters_public_subnets" {
  type        = "list"
  description = "The list of public subnets used by master elb"
}

variable "nodes_instance_type" {
  type        = "string"
  description = "The EC2 InstanceType"
}

variable "ci_allowed_ips" {
  type        = "list"
  description = "The list of allowed IP addresses CI granted access"
  default     = []
}

variable "allowed_ips" {
  type        = "list"
  description = "The list of allowed IP addresses granted access"
  default     = []
}

variable "cluster_zone_id" {
  type        = "string"
  description = "The R53 Zone ID associated with the cluster"
}

variable "private_subnet_ids" {
  type        = "list"
  description = "List of subnet_ids the masters will use"
}

variable "private_subnet_cidrs" {
  type        = "list"
  description = "List of subnet_ids the masters will use"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "List of subnet_ids the masters will use"
}

variable "public_subnet_cidrs" {
  type        = "list"
  description = "List of subnet_ids the masters will use"
}

variable "vpc_cidr" {
  type        = "string"
  description = "The VPC CIDR block associated with the VPC"
}

variable "cost_center" {
  type        = "string"
  description = "Cost Center ID"
}
