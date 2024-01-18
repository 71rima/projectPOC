# route53.tf
aliases = {
  "alias1" = "elshennawy.de"
  "alias2" = "web.elshennawy.de"
}
# alb.tf
certificate_arn = "arn:aws:acm:us-east-1:870615114862:certificate/f76ae0a8-0a5a-4c18-acc3-698decb30ce1"
