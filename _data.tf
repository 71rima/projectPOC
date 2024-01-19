#find hosted zone id
data "aws_route53_zone" "this" {
  name         = "elshennawy.de"
  private_zone = false
}
#statestorage
data "aws_s3_bucket" "this" {
  bucket = "tfstatestorage-projectpoc"
}
#alb logs: s3, policy
data "aws_s3_bucket" "alblogs" {
  bucket = "alb-alogs-projectpoc"
}
data "aws_elb_service_account" "lb" {}
data "aws_iam_policy_document" "lb_logs" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.lb.arn]
    }

    actions   = ["s3:PutObject"]
    resources = ["${data.aws_s3_bucket.alblogs.arn}/*"]
  }
}
