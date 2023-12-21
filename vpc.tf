

 terraform {
   backend "s3" {
     bucket         = "tfstatestorage-projectpoc"
     key            = "terraform.tfstate"
     region         = "us-east-1"
     dynamodb_table = "terraform_state"
   }
 }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "my-vpc-projectPOC"
  cidr = local.vpc_cidr

  azs              = ["us-east-1a", "us-east-1b"]
  private_subnets  = ["10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.0.0/24", "10.0.1.0/24"]
  database_subnets = ["10.0.4.0/24", "10.0.5.0/24"]

  enable_nat_gateway = true
  #one_nat_gateway_per_az = true
  

  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "vpc"
  }
}

