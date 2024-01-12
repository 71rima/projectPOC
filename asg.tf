resource "aws_autoscaling_group" "myasg" {
  desired_capacity  = 2
  max_size          = 3
  min_size          = 1
  depends_on        = [aws_alb.myalb]
  target_group_arns = ["${aws_lb_target_group.mytg.arn}"]
  health_check_type = "EC2"
  launch_template {
    id      = aws_launch_template.mylaunchtemplate.id
    version = aws_launch_template.mylaunchtemplate.latest_version
  }


  vpc_zone_identifier = module.vpc.private_subnets


}

#target group für ALB/ASG
resource "aws_lb_target_group" "mytg" {
  name       = "mytgnginx"
  depends_on = [module.vpc]
  port       = 80
  protocol   = "HTTP"
  vpc_id     = module.vpc.vpc_id
  health_check {
    interval            = 70
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}
