resource "aws_iam_user" "kops" {
  name = "kops-taskapp"
  path = "/kops/"
  tags = { Purpose = "kops-cluster-management" }
}
resource "aws_iam_access_key" "kops" {
  user = aws_iam_user.kops.name
}
locals {
  kops_policies = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
  ]
}
resource "aws_iam_user_policy_attachment" "kops" {
  count      = length(local.kops_policies)
  user       = aws_iam_user.kops.name
  policy_arn = local.kops_policies[count.index]
}
resource "aws_iam_role" "masters" {
  name = "masters.${var.cluster_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}
resource "aws_iam_role_policy" "masters" {
  name = "masters.${var.cluster_name}"
  role = aws_iam_role.masters.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ec2:*", "elasticloadbalancing:*",
        "ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer", "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories", "ecr:ListImages", "ecr:BatchGetImage",
        "route53:*", "s3:*", "iam:PassRole", "iam:GetRole",
        "iam:CreateServiceLinkedRole", "kms:DescribeKey"
      ]
      Resource = "*"
    }]
  })
}
resource "aws_iam_instance_profile" "masters" {
  name = "masters.${var.cluster_name}"
  role = aws_iam_role.masters.name
}
resource "aws_iam_role" "nodes" {
  name = "nodes.${var.cluster_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}
resource "aws_iam_role_policy" "nodes" {
  name = "nodes.${var.cluster_name}"
  role = aws_iam_role.nodes.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ec2:Describe*", "ec2:AttachVolume", "ec2:DetachVolume",
        "ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer", "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories", "ecr:ListImages", "ecr:BatchGetImage",
        "s3:GetBucketLocation", "s3:GetEncryptionConfiguration",
        "s3:ListBucket", "s3:GetObject"
      ]
      Resource = "*"
    }]
  })
}
resource "aws_iam_instance_profile" "nodes" {
  name = "nodes.${var.cluster_name}"
  role = aws_iam_role.nodes.name
}
