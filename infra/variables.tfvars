variable "environment" {
  default = "Stage"
}

variable "cidr_block" {
  type    = string
  default = "172.16.0.0/16"
}

variable "private_subnet" {
  type    = list(string)
  default = ["172.16.1.0/24", "172.16.2.0/24"]
}

variable "public_subnet" {
  type    = list(string)
  default = ["172.16.10.0/24", "172.16.11.0/24"]
}