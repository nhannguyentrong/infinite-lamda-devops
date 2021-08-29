data "aws_availability_zones" "available" {
    state = "available"
}

locals {
    availability_zones = data.aws_availability_zones.available.names
}

variable "vpc_name" {
    type = string
}
variable "vpc_cidr" {
    type = string

}


variable "vpc_public_subnets" {
    type = list(string)
}

variable "vpc_private_subnets" {
    type = list(string)
}