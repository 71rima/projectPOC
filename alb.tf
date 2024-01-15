resource "aws_alb" "this" {
  name               = "nginxalb"
  internal           = false
  load_balancer_type = "application"

  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.elb.id]
  #checkov
  enable_deletion_protection = true
  access_logs {
    bucket  = aws_s3_bucket.alblogs.id
    prefix  = "alb-alogs"
    enabled = true
  }
  drop_invalid_header_fields = true #drop http headers
}

/* #aws waf for public facing lb
resource "aws_wafregional_web_acl_association" "this" {
  resource_arn = aws_alb.this.arn
  web_acl_id   = aws_wafregional_web_acl.this.id
}*/

# ALB listener
resource "aws_lb_listener" "https_redirect" {
  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_alb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
#wieso loop wenn nicht hardcoded certificate arn in myalb listener?! ->depends on?!
resource "aws_lb_listener_certificate" "this" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.certificate_arn
}
