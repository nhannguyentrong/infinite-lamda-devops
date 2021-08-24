resource "aws_security_group" "db_sg" {
    name = "SG-Database"
    vpc_id = module.vpc_custom.vpc_id
}



# data "terraform_remote_state" "db" {
#   backend = "s3"

#   config = {
#     bucket = "infinite-terraform-tfstate"
#     key    = "terraform.tfstate"
#     region = "us-west-2"
#   }
# }


resource "aws_security_group_rule" "db_sgr_inbound" {
    type = "ingress"
    from_port = var.db_port
    to_port = var.db_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "db_sgr_outbound" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.db_sg.id
    
}

resource "random_password" "db_password" {
  length = 16
  special = false
}
module "database_instance" {
    source = "../../modules/database"
    db_instance_class = var.db_instance_class
    db_name = var.db_name
    db_username = var.db_username
    db_password = random_password.db_password.result
    db_port = var.db_port
    db_subnet = module.vpc_custom.private_subnets
    db_security_group = [aws_security_group.db_sg.id]
    ssm_db_credentials = var.ssm_db_credentials
}