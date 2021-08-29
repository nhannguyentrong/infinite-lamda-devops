variable "erc_repository_name" {
  type = string
  default = "flask-postgress-ecr"
}
variable "code_build_project" {
  type = string
  default = "flask-postgress-ecr"

}

# Repository name: need create before
variable "repository_name_flask" {
  type    = string
  default = "flask_postgres"
}

# Repository name: need create before
variable "repository_branch_flask" {
  type = string
  default = "main"
}
