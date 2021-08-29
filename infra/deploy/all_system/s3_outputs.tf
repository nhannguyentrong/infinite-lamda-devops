output "s3_static_bucket_name" {
  value= module.s3_static_bucket.s3_static_bucket_name
}
output "s3_static_website_endpoint" {
    value = module.s3_static_bucket.s3_static_website_endpoint
}