variable "repository_name" {
    type = string
}

variable "repository_branch" {
    type = string
}

variable "pipeline_name" {
    type = string
}

variable "project" {
  type=string
}

variable "s3_destination" {
    type = string
}
variable "tags" {
    type = map(string)
    # project=> deploy_static, environemnt => stage
}