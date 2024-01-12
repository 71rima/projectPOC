resource "aws_launch_template" "this" {
  name = "launchtemplate_nginx"

  image_id               = data.aws_ami.latest_linux.image_id #var.linux_image_id
  vpc_security_group_ids = ["${aws_security_group.nginx.id}"]
  instance_type          = var.instance_type

  user_data = filebase64("${path.module}/user_data.sh")
}

