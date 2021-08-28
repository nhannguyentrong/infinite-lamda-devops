variable "my_tags" {
    type = map(string)
    default = {
      "Environment" = "Stage",
      "Terraform" = "true"
    }
}

######## For Static Deploy ####


variable "tags" {
    type = map(string)
    default = {
      "project" = "static_html",
      "environment" = "stage"
    }
}



variable "db_name" {
    type = string
    default = "nhannguyenpostgres"
}

variable "db_identifier" {
    type = string
    default = "nhannguyen-postgres"
  
}

variable "db_instance_class" {
    type = string
    default = "db.t2.micro"
}

variable "db_username" {
    type = string
    default = "nhannguyen"
}

variable "db_port" {
    type = number  
    default = 55432
  
}

variable "ssm_db_credentials" {
    type = string
    default = "/rds/postgress/credentials"
  
}