# security group for ALB
resource "aws_security_group" "elb_sg" {   
  name        = "sg_alb"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id
ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
 tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "mysg_alb"
  } 
}

# security group for webserver
resource "aws_security_group" "nginx_sg" {
  name        = "sg_nginx"
  description = "Security Group for Nginx Webserver"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
   } 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  /*ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }*/ #intern wird http verwendet deswegen muss https nicht offen sein
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "mysg_nginx"
  }
}