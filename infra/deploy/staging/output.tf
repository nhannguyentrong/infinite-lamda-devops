output "s3_static_website_endpoint" {
    value = module.s3_static_bucket.s3_static_website_endpoint
}
output "vpc_custom_id" {
    value = module.vpc_custom.vpc_id
  
}