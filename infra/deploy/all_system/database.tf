
resource "random_password" "db_password" {
  length = 16
  special = false
}

resource "random_string" "resource_name" {
  length = 5
  special = false
  upper = false
}
module "database_instance" {
    source = "../../modules/database"

    ##for VPC
    vpc_private_subnets = var.vpc_private_subnets
    vpc_cidr = var.vpc_cidr
    vpc_public_subnets = var.vpc_public_subnets
    vpc_name = "${var.vpc_name}_${random_string.resource_name.result}"

    ##For database

    db_instance_class = var.db_instance_class
    db_name = var.db_name
    db_username = var.db_username
    db_identifier = "${var.db_identifier}-${random_string.resource_name.result}"
    db_password = random_password.db_password.result
    db_port = var.db_port
    ssm_db_credentials = "${var.ssm_db_credentials}_${random_string.resource_name.result}"

    publicly_accessible = true
}