module "deploy_static" {
  source = "../../modules/deploy_static"
  repository_name = var.repository_name
  repository_branch = var.repository_branch
  pipeline_name = var.pipeline_name
  project = var.project
  s3_destination = module.s3_static_bucket.s3_static_bucket_name
  tags = var.tags
}