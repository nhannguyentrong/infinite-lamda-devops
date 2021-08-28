resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = var.db_subnet
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
    vpc_security_group_ids = var.db_security_group
    
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
    name = "get_ssm_db_credential"
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