output "s3_static_website_endpoint" {
    value = aws_s3_bucket.s3_static_web.website_endpoint
}
output "s3_static_bucket_name" {
    value = aws_s3_bucket.s3_static_web.id
}