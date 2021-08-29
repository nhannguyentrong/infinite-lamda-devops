# variable "my_tags" {
#     type = map(string)
#     default = {
#       "Environment" = "Stage",
#       "Terraform" = "true"
#     }
# }

######## For Static Deploy ####


# variable "tags" {
#     type = map(string)
#     default = {
#       "project" = "static_html",
#       "environment" = "stage"
#     }
# }


# database variable

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

### VPC  Variable ###

variable "vpc_name" {
    type = string
    default = "All Deploy VPC"
}
variable "vpc_cidr" {
    type = string
    default = "172.16.0.0/16"
    description = "VPC CIDR"
}

variable "vpc_public_subnets" {
    type = list(string)
    default = [ "172.16.1.0/24","172.16.2.0/24" ]
}

variable "vpc_private_subnets" {
    type = list(string)
    default = [ "172.16.10.0/24","172.16.11.0/24" ]
}