module "s3_static_bucket" {
    source = "../../modules/s3_static_bucket"
    s3_bucket_name = var.s3_bucket_name
    tags = var.my_tags
}