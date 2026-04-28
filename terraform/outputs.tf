output "vpc_id" {
  value = module.vpc.vpc_id
}
output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
output "route53_name_servers" {
  description = "Add ALL FOUR of these as NS records at your registrar"
  value       = module.dns.name_servers
}
output "kops_access_key_id" {
  value     = module.iam.kops_access_key_id
  sensitive = true
}
output "kops_secret_access_key" {
  value     = module.iam.kops_secret_access_key
  sensitive = true
}
