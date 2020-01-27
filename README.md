## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_ips | The list of allowed IP addresses granted access | list | `<list>` | no |
| ci\_allowed\_ips | The list of allowed IP addresses CI granted access | list | `<list>` | no |
| cluster\_name | The KubernetesCluster name | string | - | yes |
| cluster\_zone\_id | The R53 Zone ID associated with the cluster | string | - | yes |
| config\_bucket | The S3 storage bucket used for configurations | string | - | yes |
| cost\_center | Cost Center ID | string | - | yes |
| env | The environment name | string | - | yes |
| etcd\_events\_ebs\_size | The EBS Volume size for etcd-events. Defaults to 100GB | string | `100` | no |
| etcd\_events\_ebs\_type | The EBS Volume type for etcd-events. Defaults to gp2 | string | `gp2` | no |
| etcd\_events\_encrypted | Boolean to enabled encrypted EBS volumes for etcd-events. Defaults to false | string | `false` | no |
| etcd\_main\_ebs\_size | The EBS Volume size for etcd-main. Defaults to 100GB | string | `100` | no |
| etcd\_main\_ebs\_type | The EBS Volume type for etcd-main. Defaults to gp2 | string | `gp2` | no |
| etcd\_main\_encrypted | Boolean to enabled encrypted EBS volumes for etcd-main. Defaults to false | string | `false` | no |
| kinesis\_stream\_cloudwatch\_log\_arn | - | string | - | yes |
| kinesis\_stream\_cloudwatch\_log\_role\_arn | - | string | - | yes |
| kinesis\_stream\_filter\_pattern | A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events. | string | `[]` | no |
| masters\_availability\_zones | The list of availability zones to launch masters in | list | - | yes |
| masters\_instance\_type | The instance type used for master instance | string | - | yes |
| masters\_private\_subnet\_ids | List of subnet_ids the masters will use | list | - | yes |
| masters\_public\_subnets | The list of public subnets used by master elb | list | - | yes |
| masters\_root\_volume\_size | The EBS volume size for masters. Defaults to 100GB | string | `100` | no |
| masters\_root\_volume\_type | The EBS volume type for masters. Dfaults to gp2 | string | `gp2` | no |
| masters\_ssh\_key\_name | The ssh-key name to use for masters instances | string | - | yes |
| nodes\_asg\_max\_size | The MAX_SIZE set for nodes AutoScalingGroup. Defaults to 5 | string | `5` | no |
| nodes\_asg\_min\_size | The MIN_SIZE set for nodes AutoScalingGroup. Defaults to 5 | string | `5` | no |
| nodes\_instance\_type | The EC2 InstanceType | string | - | yes |
| nodes\_private\_subnet\_ids | The list of subnet_ids nodes can use | list | - | yes |
| nodes\_root\_volume\_size | The root volume EBS volume size. Defaults to 100GB | string | `100` | no |
| nodes\_root\_volume\_type | The root volume EBS volume type. Defaults to gp2 | string | `gp2` | no |
| nodes\_ssh\_key\_name | The ssh-key name to associate with nodes instances | string | - | yes |
| private\_subnet\_cidrs | List of subnet_ids the masters will use | list | - | yes |
| private\_subnet\_ids | List of subnet_ids the masters will use | list | - | yes |
| project\_name | The project name | string | - | yes |
| public\_subnet\_cidrs | List of subnet_ids the masters will use | list | - | yes |
| public\_subnet\_ids | List of subnet_ids the masters will use | list | - | yes |
| vpc\_cidr | The VPC CIDR block associated with the VPC | string | - | yes |
| vpc\_id | The VpcId in which Kubernetes will live | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| api\_dns\_name | The DNS name for Masters API server |
| api\_password | - |
| api\_username | The Username used to communicate with the API |
| masters\_instance\_profile | This is the ARN for the masters instance profile |
| nodes\_instance\_profile | This is the ARN for the nodes instance profile |
| nodes\_instance\_profile\_arn | This is the ARN for the nodes instance profile |
| nodes\_security\_group\_id | The SG-id of the Kubernetes Ndoes |

