resource "aws_launch_template" "this" {
  name = "launchtemplateMynginx"

  image_id               = "ami-079db87dc4c10ac91"
  vpc_security_group_ids = ["${aws_security_group.nginx.id}"]
  instance_type          = "t2.micro"
  /*network_interfaces {
    associate_public_ip_address = false
    #security_groups = [  "${aws_security_group.nginx_sg.id}" ]
  }*/


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "testNginx"
    }
  }

  user_data = filebase64("${path.module}/user_data.sh")
}

