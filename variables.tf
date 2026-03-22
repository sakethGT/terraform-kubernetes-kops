variable "kinesis_stream_cloudwatch_log_arn" {
  type        = string
  description = "The ARN of the Kinesis stream for CloudWatch log delivery"
}

variable "kinesis_stream_cloudwatch_log_role_arn" {
  type        = string
  description = "The ARN of the IAM role for CloudWatch log delivery to Kinesis"
}

variable "kinesis_stream_filter_pattern" {
  type        = string
  description = "A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events."
  default     = "[]"
}

variable "cluster_name" {
  type        = string
  description = "The KubernetesCluster name"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID in which Kubernetes will live"
}

variable "etcd_events_ebs_size" {
  type        = number
  description = "The EBS volume size (GB) for etcd-events"
  default     = 100
}

variable "etcd_events_ebs_type" {
  type        = string
  description = "The EBS volume type for etcd-events"
  default     = "gp2"
}

variable "etcd_events_encrypted" {
  type        = bool
  description = "Whether to encrypt EBS volumes for etcd-events"
  default     = false
}

variable "etcd_main_ebs_size" {
  type        = number
  description = "The EBS volume size (GB) for etcd-main"
  default     = 100
}

variable "etcd_main_ebs_type" {
  type        = string
  description = "The EBS volume type for etcd-main"
  default     = "gp2"
}

variable "etcd_main_encrypted" {
  type        = bool
  description = "Whether to encrypt EBS volumes for etcd-main"
  default     = false
}

variable "masters_availability_zones" {
  type        = list(string)
  description = "The list of availability zones to launch masters in"
}

variable "env" {
  type        = string
  description = "The environment name"
}

variable "nodes_root_volume_type" {
  type        = string
  description = "The root volume EBS volume type for worker nodes"
  default     = "gp2"
}

variable "nodes_root_volume_size" {
  type        = number
  description = "The root volume EBS volume size (GB) for worker nodes"
  default     = 100
}

variable "project_name" {
  type        = string
  description = "The project name"
}

variable "nodes_ssh_key_name" {
  type        = string
  description = "The SSH key name to associate with worker node instances"
}

variable "masters_private_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs the masters will use"
}

variable "config_bucket" {
  type        = string
  description = "The S3 bucket used for kops state store and configurations"
}

variable "nodes_asg_max_size" {
  type        = number
  description = "The maximum size of the worker nodes Auto Scaling Group"
  default     = 5
}

variable "nodes_asg_min_size" {
  type        = number
  description = "The minimum size of the worker nodes Auto Scaling Group"
  default     = 5
}

variable "nodes_private_subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs worker nodes can use"
}

variable "masters_ssh_key_name" {
  type        = string
  description = "The SSH key name to use for master instances"
}

variable "masters_instance_type" {
  type        = string
  description = "The instance type used for master instances"
}

variable "masters_root_volume_size" {
  type        = number
  description = "The EBS volume size (GB) for masters"
  default     = 100
}

variable "masters_root_volume_type" {
  type        = string
  description = "The EBS volume type for masters"
  default     = "gp2"
}

variable "masters_public_subnets" {
  type        = list(string)
  description = "The list of public subnets used by the master API ELB"
}

variable "nodes_instance_type" {
  type        = string
  description = "The EC2 instance type for worker nodes"
}

variable "ci_allowed_ips" {
  type        = list(string)
  description = "The list of CIDR blocks granted CI access to the API server"
  default     = []
}

variable "allowed_ips" {
  type        = list(string)
  description = "The list of CIDR blocks granted access to the API server"
  default     = []
}

variable "cluster_zone_id" {
  type        = string
  description = "The Route53 Zone ID associated with the cluster"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the cluster"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the cluster"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR block"
}

variable "cost_center" {
  type        = string
  description = "Cost center tag for resource tracking"
}
