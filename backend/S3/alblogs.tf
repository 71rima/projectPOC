resource "aws_s3_bucket" "alblogs" {
  bucket = "alb-alogs-projectpoc"
}      
resource "aws_s3_bucket_policy" "lb_logs" {
  bucket = data.aws_s3_bucket.alblogs.id
  policy = data.aws_iam_policy_document.lb_logs.json
}


