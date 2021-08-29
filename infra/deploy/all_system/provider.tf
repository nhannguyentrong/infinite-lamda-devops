provider "aws" {
  region  = "us-west-2"
  profile = "infinite-lamda-devops"
}
terraform {
  backend "s3" {
    bucket         = "infinite-terraform-tfstate"
    key            = "all_terraform.tfstate"
    dynamodb_table = "app-state"
    region         = "us-west-2"
    profile        = "infinite-lamda-devops"
  }
}