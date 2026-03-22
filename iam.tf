# IAM roles and policies for master and worker nodes.
# Masters need broader permissions (EC2, ELB, Route53, ASG) to manage cluster
# infrastructure. Nodes get minimal permissions scoped to their S3 paths
# and ECR for container image pulls.

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid = "1"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "masters" {
  statement {
    sid = "K8sEC2MasterPermsDescribeResources"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
    ]

    resources = ["*"]
  }

  statement {
    sid = "K8sEC2MasterPermsAllResources"

    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:ModifyInstanceAttribute",
    ]

    resources = ["*"]
  }

  statement {
    sid = "K8sEC2MasterPermsTaggedResources"

    actions = [
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteVolume",
      "ec2:DetachVolume",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/KubernetesCluster"
      values   = [var.cluster_name]
    }
  }

  statement {
    sid = "K8sASMasterPermsAllResources"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:GetAsgForInstance",
    ]

    resources = ["*"]
  }

  statement {
    sid = "K8sASMasterPermsTaggedResources"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/KubernetesCluster"
      values   = [var.cluster_name]
    }
  }

  statement {
    sid = "K8sELBMasterPermsRestrictive"

    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:AttachLoadBalancerToSubnets",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateLoadBalancerPolicy",
      "elasticloadbalancing:CreateLoadBalancerListeners",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancerListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DetachLoadBalancerFromSubnets",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
    ]

    resources = ["*"]
  }

  statement {
    sid = "K8sNLBMasterPermsRestrictive"

    actions = [
      "ec2:DescribeVpcs",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
    ]

    resources = ["*"]
  }

  statement {
    sid = "MasterCertIAMPerms"

    actions = [
      "iam:ListServerCertificates",
      "iam:GetServerCertificate",
    ]

    resources = ["*"]
  }

  statement {
    sid = "K8sS3GetListBucket"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.config_bucket}",
    ]
  }

  statement {
    sid = "K8sS3MasterBucketFullGet"

    actions = [
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::${var.config_bucket}/${var.cluster_name}/*",
    ]
  }

  statement {
    sid = "K8sECR"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
  }

  statement {
    sid = "K8sR53FullGet"

    actions = [
      "route53:ListHostedZones",
    ]

    resources = ["*"]
  }

  statement {
    sid = "K8sR53Changed"

    actions = [
      "route53:GetChange",
    ]

    resources = [
      "arn:aws:route53:::change/*",
    ]
  }

  statement {
    sid = "K8sR53Restricted"

    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:GetHostedZone",
      "route53:ListHostedZones",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${var.cluster_zone_id}",
    ]
  }

  statement {
    sid = "CloudWatchLogs"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

data "aws_iam_policy_document" "nodes" {
  statement {
    sid = "kopsK8sEC2NodePerms"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
    ]

    resources = ["*"]
  }

  statement {
    sid = "kopsK8sS3GetListBucket"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.config_bucket}",
    ]
  }

  statement {
    sid = "kopsK8sS3NodeBucketSelectiveGet"

    actions = [
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::${var.config_bucket}/${var.cluster_name}/addons/*",
      "arn:aws:s3:::${var.config_bucket}/${var.cluster_name}/cluster.spec",
      "arn:aws:s3:::${var.config_bucket}/${var.cluster_name}/config",
      "arn:aws:s3:::${var.config_bucket}/${var.cluster_name}/instancegroup/*",
      "arn:aws:s3:::${var.config_bucket}/${var.cluster_name}/pki/issued/*",
      "arn:aws:s3:::${var.config_bucket}/${var.cluster_name}/pki/private/kube-proxy/*",
      "arn:aws:s3:::${var.config_bucket}/${var.cluster_name}/pki/private/kubelet/*",
      "arn:aws:s3:::${var.config_bucket}/${var.cluster_name}/pki/ssh/*",
      "arn:aws:s3:::${var.config_bucket}/${var.cluster_name}/secrets/dockerconfig",
    ]
  }

  statement {
    sid = "K8sECR"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
  }

  statement {
    sid = "K8sMetricsAndAssumeRole"

    actions = [
      "cloudwatch:putMetricData",
      "sts:AssumeRole",
    ]

    resources = ["*"]
  }

  statement {
    sid = "k8sClusterAutoscaler"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]

    resources = ["*"]
  }

  statement {
    sid = "CloudWatchLogs"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_instance_profile" "masters" {
  name = "masters.${var.cluster_name}"
  role = aws_iam_role.masters.id
}

resource "aws_iam_role" "masters" {
  name               = "masters.${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "nodes" {
  name = "nodes.${var.cluster_name}"
  role = aws_iam_role.nodes.id
}

resource "aws_iam_role" "nodes" {
  name               = "nodes.${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "masters" {
  name   = "masters.${var.cluster_name}"
  role   = aws_iam_role.masters.id
  policy = data.aws_iam_policy_document.masters.json
}

resource "aws_iam_role_policy" "nodes" {
  name   = "nodes.${var.cluster_name}"
  role   = aws_iam_role.nodes.id
  policy = data.aws_iam_policy_document.nodes.json
}
