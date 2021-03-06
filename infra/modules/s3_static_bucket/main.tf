resource "random_string" "resource_name" {
  length = 5
  special = false
  upper = false
}
resource "aws_s3_bucket" "s3_static_web" {
  bucket = "${var.s3_bucket_name}-${random_string.resource_name.result}"
  acl    = "public-read"
  website {
    index_document = "index.html"
  }
  force_destroy = true
}

resource "aws_s3_bucket_policy" "s3_static_web_policy" {
  bucket = aws_s3_bucket.s3_static_web.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "s3:GetObject",
          "Resource" : "${aws_s3_bucket.s3_static_web.arn}/*"
        }
      ]
  })
}