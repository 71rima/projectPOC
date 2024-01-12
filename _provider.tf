terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.26"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = local.region
  shared_config_files      = ["/Users/amirel-shennawy/.aws/config"]
  shared_credentials_files = ["/Users/amirel-shennawy/.aws/credentials"]
}
