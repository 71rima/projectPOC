/*
data "aws_ami" "latest_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "description"
    values = ["Amazon Linux 2 AMI*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["*-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
} */ 
#find newest ami aws linux
data "aws_ami" "latest_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "description"
    values = ["Amazon Linux 2023 AMI*"]
  }
}
data "aws_elb_service_account" "lb" {}
data "aws_iam_policy_document" "lb_logs" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.lb.arn]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.alblogs.arn}/*"]
  }
}
#find hosted zone id
data "aws_route53_zone" "this" {
  name         = "elshennawy.de"
  private_zone = false
}