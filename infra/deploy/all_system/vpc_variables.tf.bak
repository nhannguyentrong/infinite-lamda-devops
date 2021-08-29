data "aws_availability_zones" "available" {
    state = "available"
}

locals {
    availability_zones = data.aws_availability_zones.available.names
}

variable "vpc_name" {
    type = string
    default = "Stage VPC"
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
