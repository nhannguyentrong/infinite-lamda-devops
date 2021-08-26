output "endpoint" {
    value = aws_db_instance.database_instance.endpoint
}

output "domain" {
    value = aws_db_instance.database_instance.domain
}

output "address" {
    value = aws_db_instance.database_instance.address
}

output "ssm_database_credential" {
    value = aws_ssm_parameter.ssm_database_credential.arn
}

output "pol_get_ssm_db_credential" {
    value = aws_iam_policy.pol_get_ssm_db_credential.arn
}