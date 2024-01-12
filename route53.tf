


resource "aws_route53_record" "alias_domain" {
  zone_id = "Z0658112WEOSUCBEMGYV"
  name    = "elshennawy.de"
  type    = "A"

  alias {
    name                   = aws_alb.this.dns_name
    zone_id                = aws_alb.this.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "alias_subdomain" {
  zone_id = "Z0658112WEOSUCBEMGYV"
  name    = "web.elshennawy.de"
  type    = "A"

  alias {
    name                   = aws_alb.this.dns_name
    zone_id                = aws_alb.this.zone_id
    evaluate_target_health = true
  }
}
