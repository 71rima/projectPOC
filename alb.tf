resource "aws_alb" "this" {
  name               = "alb-${local.project_name}"
  internal           = false
  load_balancer_type = "application"

  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.alb.id]
  #checkov
  #enable_deletion_protection = true
  access_logs {
    bucket  = data.aws_s3_bucket.alblogs.id
    prefix  = "alb-alogs"
    enabled = true
  }
  drop_invalid_header_fields = true #drop http headers
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
  certificate_arn   = var.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

#Certificate for TLS/SSL
#wieso loop wenn nicht hardcoded certificate arn in myalb listener?! ->depends on?!
resource "aws_lb_listener_certificate" "this" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.certificate_arn
}

#Target Group for ALB/ECS
resource "aws_lb_target_group" "this" {
  target_type = "ip" #default type: instance is not compatible with awsvpc network mode in task definitiongo
  depends_on  = [module.vpc]
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  health_check {
    interval            = 70
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 60
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}
