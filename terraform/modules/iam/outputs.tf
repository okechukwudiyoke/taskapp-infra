output "kops_user_arn" { value = aws_iam_user.kops.arn }
output "kops_access_key_id" {
  value     = aws_iam_access_key.kops.id
  sensitive = true
}
output "kops_secret_access_key" {
  value     = aws_iam_access_key.kops.secret
  sensitive = true
}
output "masters_instance_profile_arn" { value = aws_iam_instance_profile.masters.arn }
output "nodes_instance_profile_arn" { value = aws_iam_instance_profile.nodes.arn }
