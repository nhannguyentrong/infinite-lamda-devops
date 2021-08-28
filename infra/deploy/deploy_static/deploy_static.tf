data "terraform_remote_state" "s3_bucket" {
  backend = "s3"

  config = {
    bucket         = "infinite-terraform-tfstate"
    key            = "s3_terraform.tfstate"
    region = "us-west-2"
    profile        = "infinite-lamda-devops"    
  }
}

module "deploy_static" {
  source = "../../modules/deploy_static"
  repository_name = var.repository_name
  repository_branch = var.repository_branch
  pipeline_name = var.pipeline_name
  project = var.project
  s3_destination = data.terraform_remote_state.s3_bucket.outputs.s3_static_bucket_name
  tags = var.tags
}

output "s3_static_bucket_endpoint" {
  value = data.terraform_remote_state.s3_bucket.outputs.s3_static_website_endpoint
}