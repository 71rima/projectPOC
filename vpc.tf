module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=e4768508a17f79337f9f1e48ebf47ee885b98c1f"

  name = "vpc-projectPOC"

  cidr = local.vpc_cidr

  azs              = ["us-east-1a", "us-east-1b"]
  private_subnets  = ["10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.0.0/24", "10.0.1.0/24"]
  database_subnets = ["10.0.4.0/24", "10.0.5.0/24"]

  enable_nat_gateway = true
}



