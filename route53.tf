


resource "aws_route53_record" "alias1" {
  zone_id = "Z0658112WEOSUCBEMGYV"
  name    = "elshennawy.de"
  type    = "A"
  
  alias {
    name                   = aws_alb.myalb.dns_name
    zone_id                = aws_alb.myalb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "alias2" {
  zone_id = "Z0658112WEOSUCBEMGYV"
  name    = "web.elshennawy.de"
  type    = "A"
  
  alias {
    name                   = aws_alb.myalb.dns_name
    zone_id                = aws_alb.myalb.zone_id
    evaluate_target_health = true
  }
}