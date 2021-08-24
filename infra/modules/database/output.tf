output "endpoint" {
    value = aws_db_instance.database_instance.endpoint
}

output "domain" {
    value = aws_db_instance.database_instance.domain
}

output "address" {
    value = aws_db_instance.database_instance.address
}
