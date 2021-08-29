
resource "random_string" "resource_name" {
  length = 5
  special = false
  upper = false
}
module "s3_static_bucket" {
    source = "../../modules/s3_static_bucket"
    s3_bucket_name = "${var.s3_bucket_name}-${random_string.resource_name.result}"
}