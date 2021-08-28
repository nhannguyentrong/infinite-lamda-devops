variable "db_name" {
    type = string
}
variable "db_instance_class" {
    type = string
}

variable "db_username" {
    type = string
}

variable "db_identifier" {
    type =string
}

variable "db_password" {
    type = string
}

variable "db_port" {
    type = number  
  
}

variable "publicly_accessible" {
    type = bool
  
}

variable "db_security_group" {
    type = list(string)
}

variable "db_subnet" {
    type = any
}

variable "ssm_db_credentials" {
    type = string
  
}