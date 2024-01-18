#target group für ALB/ECS_Service
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
