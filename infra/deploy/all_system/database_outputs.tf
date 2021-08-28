output "db_endpoint" {
    value = module.database_instance.endpoint
}

output "db_domain" {
    value = module.database_instance.domain
}

output "db_address" {
    value = module.database_instance.address
}

output "ssm_db_credentials" {
    value = var.ssm_db_credentials
}