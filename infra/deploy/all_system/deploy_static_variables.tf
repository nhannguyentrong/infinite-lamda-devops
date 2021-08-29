variable "repository_name_static" {
    type = string
    default = "static_html"
}

variable "repository_branch_static" {
    type = string
    default = "main"
}

variable "pipeline_name" {
    type = string
    default = "deploy-static-html"
}

variable "project" {
  type= string
  default = "static_html"
}

variable "tags" {
  type = map(string)
  default = {
    "project" = "static_html_deploy"
  }

}