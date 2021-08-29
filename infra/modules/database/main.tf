resource "random_string" "resource_name" {
  length = 5
  special = false
  upper = false
}
resource "aws_security_group" "db_sg" {
    name = "database-security-group-${random_string.resource_name.result}"
    vpc_id = module.vpc_custom.vpc_id
    tags = {
      "Name" = "database-security-group-${random_string.resource_name.result}"
    }
}

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


resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group_${random_string.resource_name.result}"
  subnet_ids = module.vpc_custom.public_subnets
}


resource "aws_db_instance" "database_instance" {
    allocated_storage = 20
    engine = "postgres"
    engine_version = "12.6"
    instance_class = var.db_instance_class
    name = var.db_name
    identifier = var.db_identifier
    username = var.db_username
    password = var.db_password
    port = var.db_port
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    vpc_security_group_ids = [aws_security_group.db_sg.id]
    
    skip_final_snapshot  = true
    backup_retention_period = 0
    apply_immediately    = true
    publicly_accessible = var.publicly_accessible
}


resource "aws_ssm_parameter" "ssm_database_credential" {
    name = var.ssm_db_credentials
    type = "SecureString"
    value = jsonencode({
      "db_name":"${var.db_name}",
      "db_username":"${var.db_username}",
      "db_password":"${var.db_password}",
      "db_port":"${var.db_port}",
      "db_address":"${aws_db_instance.database_instance.address}"
    })
}

resource "aws_iam_policy" "pol_get_ssm_db_credential" {
    name = "get_ssm_db_credential_${random_string.resource_name.result}"
    path = "/"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [{
          "Action" : "ssm:GetParameter"
          "Effect": "Allow"
          "Resource": aws_ssm_parameter.ssm_database_credential.arn
      }]
    })
}