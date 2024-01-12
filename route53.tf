

/*
resource "aws_route53_record" "alias_domain" {
  
  zone_id = aws_alb.this.zone_id
  name    = "elshennawy.de"
  type    = "A"

  alias {
    name                   = aws_alb.this.dns_name
    zone_id                = aws_alb.this.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "alias_subdomain" {

  zone_id = aws_alb.this.zone_id
  name    = "web.elshennawy.de"
  type    = "A"

  alias {
    name                   = aws_alb.this.dns_name
    zone_id                = aws_alb.this.zone_id
    evaluate_target_health = true
  }
}*/
resource "aws_route53_record" "alias_records" {
  for_each = var.aliases

  zone_id = aws_alb.this.zone_id # aws_route53_zone.zone["zwei"].zone_id
  name    = each.key
  type    = "A"

  alias {
    name                   = each.value
    zone_id                = aws_alb.this.zone_id
    evaluate_target_health = true
  }
}
