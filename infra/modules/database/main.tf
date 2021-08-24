resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.db_subnet

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_db_instance" "database_instance" {
    allocated_storage = 20
    engine = "postgres"
    engine_version = "12.6"
    instance_class = var.db_instance_class
    name = var.db_name
    username = var.db_username
    password = var.db_password
    port = var.db_port
    db_subnet_group_name = aws_db_subnet_group.default.name
    vpc_security_group_ids = var.db_security_group
    
    skip_final_snapshot  = true
    backup_retention_period = 0
    apply_immediately    = true
}


resource "aws_ssm_parameter" "database_credentials" {
    name = var.ssm_db_credentials
    type = "SecureString"
    value = jsonencode({"db_username":"${var.db_username}","db_password":"${var.db_password}","db_port":"${var.db_port}","db_address":"${aws_db_instance.database_instance.address}"})
}