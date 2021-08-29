output "db_endpoint" {
    value = module.database_instance.endpoint
}


output "db_address" {
    value = module.database_instance.address
}

output "ssm_db_credentials" {
    value = module.database_instance.ssm_database_credential
}