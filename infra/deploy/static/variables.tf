variable "s3_bucket_name" {
    type = string
    default = "jame-nguyen-s3" 
}

variable "repository_name" {
    type = string
    default = "static_website"
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
  type=string
  default = "static_html"
}

variable "tags" {
    type = map(string)
    default = {
      "project" = "static_html",
      "environment" = "stage"
    }
}

