resource "aws_launch_template" "mylaunchtemplate" {
  name = "mynginx"

  /*iam_instance_profile {
    name = "test"
  }*/

  image_id = data.aws_ami.linux.image_id

  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
  }

 
  /*vpc_security_group_ids = ["sg-12345678"]*/

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/user_data.sh")
}