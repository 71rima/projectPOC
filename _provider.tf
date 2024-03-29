terraform {
  required_version = ">= 1.4"
  backend "s3" {
    bucket         = "tfstatestorage-projectpoc"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
  }
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
  default_tags {
    tags = {
      owner       = "TecRacer"
      project     = "ProjectPOC"
      Environment = "Dev"
      Terraform   = true
    }
  }
}
