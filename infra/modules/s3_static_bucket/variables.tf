variable "s3_bucket_name" {
    type = string
    description = "S3 bucket name"
}
variable "tags" {
    type = map(string)
    description = "Tags to apply the resource"
  
}