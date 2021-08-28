variable "repository_name" {
    type = string
    default = "static_html"
}

variable "repository_branch" {
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
