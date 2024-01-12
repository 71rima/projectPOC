resource "aws_alb" "this" {
  name               = "mynginxalb"
  internal           = false
  load_balancer_type = "application"

  subnets         = module.vpc.public_subnets
  security_groups = ["${aws_security_group.elb.id}"]

  tags = {
    name      = "this"
    Terraform = true
  }

}

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
  certificate_arn   = "arn:aws:acm:us-east-1:870615114862:certificate/f76ae0a8-0a5a-4c18-acc3-698decb30ce1"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
#wieso loop wenn nicht hardcoded certificate arn in myalb listener?! ->depends on?!
resource "aws_lb_listener_certificate" "this" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = "arn:aws:acm:us-east-1:870615114862:certificate/f76ae0a8-0a5a-4c18-acc3-698decb30ce1"
}
