output "s3_state_arn" {
  description = "The ARN of the S3 bucket for state storage."
  value       = data.aws_s3_bucket.this.arn
}
output "s3_alblogs_arn" {
  description = "The ARN of the S3 bucket for ALB Logs."
  value       = data.aws_s3_bucket.alblogs.arn
}
