locals {
  #terraform-git-repo = "projectPOC"
  region             = "us-east-1"
  vpc_cidr = "10.0.0.0/16"

  #terraform-base-path = replace(path.cwd,
  #"/^.*?(${local.terraform-git-repo}\\/)/", "$1")

}
/*terraform {
  cloud {
    organization = "amirc55c17c2"
    workspaces { name = "example-workspace" }
  }
}*/ #terraform cloud replaced with s3 and dynamo db
