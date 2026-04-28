module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
  aws_region   = var.aws_region
}
module "iam" {
  source       = "./modules/iam"
  cluster_name = var.cluster_name
}
module "dns" {
  source       = "./modules/dns"
  domain_name  = var.domain_name
  cluster_name = var.cluster_name
}
