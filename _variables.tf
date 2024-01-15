variable "aliases" {
  description = "Alias Records for domain and subdomain"
  type        = map(string)
  default = {
    "alias1" = "elshennawy.de"
    "alias2" = "web.elshennawy.de"
  }
}

/*variable "linux_image_id" {
  type        = string
  description = "The id of the Linux AMI to use for the Nginx Webserver"
  default     = "value"
}*/ #latest image id in data.tf

variable "instance_type" {
  type        = string
  description = "The instance type used for the Launch Template of the Nginx Webserver"
}
variable "certificate_arn" {
  type        = string
  description = "The ARN of the certificate used for the ALB HTTPS Listener"
}
