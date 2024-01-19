resource "aws_route53_record" "alias_domain" {

  zone_id = data.aws_route53_zone.this.zone_id
  name    = "elshennawy.de"
  type    = "A"

  alias {
    name                   = aws_alb.this.dns_name
    zone_id                = aws_alb.this.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "alias_subdomain" {

  zone_id = data.aws_route53_zone.this.zone_id
  name    = "web.elshennawy.de"
  type    = "A"

  alias {
    name                   = aws_alb.this.dns_name
    zone_id                = aws_alb.this.zone_id
    evaluate_target_health = true
  }
}

