module "deploy_docker" {
  source              = "../../modules/deploy_docker"
  erc_repository_name = var.erc_repository_name
  code_build_project  = var.code_build_project
  repository_name     = var.repository_name
  branch_name = var.branch_name

}