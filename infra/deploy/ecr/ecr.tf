variable "erc_repository_name" {
  type    = string
  default = "ecr_from_terraform"
}
variable "code_build_project" {
  type    = string
  default = "flask-project-demo"

}

# Repository name: need create before
variable "repository_name" {
  type    = string
  default = "flask_postgres"
}

# Repository name: need create before
variable "branch_name" {
  type = string
  default = "main"
}

module "ecr_build" {
  source              = "../../modules/ecr"
  erc_repository_name = var.erc_repository_name
  code_build_project  = var.code_build_project
  repository_name     = var.repository_name
  branch_name = var.branch_name

}