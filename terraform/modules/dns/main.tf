resource "aws_route53_zone" "main" {
  name = var.domain_name
  tags = { Name = var.domain_name, Purpose = "taskapp-capstone" }
}
resource "aws_route53_record" "cluster_ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.cluster_name
  type    = "NS"
  ttl     = 300
  records = aws_route53_zone.main.name_servers
}
