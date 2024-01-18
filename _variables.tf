variable "aliases" {
  description = "Alias Records for domain and subdomain"
  type        = map(string)
  default = {
    "alias1" = "elshennawy.de"
    "alias2" = "web.elshennawy.de"
  }
}
variable "certificate_arn" {
  type        = string
  description = "The ARN of the certificate used for the ALB HTTPS Listener"
}
