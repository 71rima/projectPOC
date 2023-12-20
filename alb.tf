resource "aws_alb" "myalb" {
  name               = "mynginxalb"
  internal           = false
  load_balancer_type = "application"

  subnets         = module.vpc.public_subnets
  security_groups = ["${aws_security_group.elb_sg.id}"]#[aws_security_group.elb_sg.id]

  tags =  {
     name = "myalb"
     Terraform = true
    }
  
}

# ALB listener
resource "aws_lb_listener" "myalb_listener" {
  load_balancer_arn = aws_alb.myalb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mytg.arn
  }
}