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

variable "tags" {
    type = map(string)
    default = {
      "project" = "static_html_deploy"
    }
  
}

variable "s3_destination_bucket" {
  type= string
  default = "nhan-nguyen-08282021"
}