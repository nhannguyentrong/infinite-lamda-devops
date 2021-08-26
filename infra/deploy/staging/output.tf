output "s3_static_website_endpoint" {
    value = module.s3_static_bucket.s3_static_website_endpoint
}

output "ssm_database_credential" {
    value = module.database_instance.ssm_database_credential
}

output "pol_get_ssm_db_credential" {
    value = module.database_instance.pol_get_ssm_db_credential
  
}