variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}
variable "environment" {
  type    = string
  default = "production"
}
variable "cluster_name" {
  type    = string
  default = "taskapp.okeydiyoke.com.ng"
}
variable "domain_name" {
  type    = string
  default = "okeydiyoke.com.ng"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
