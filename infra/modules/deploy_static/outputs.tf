output "aws_codepipeline_name" {
    value = aws_codepipeline.deploy_pipeline.arn
}

output "s3_output_endpoint" {
    value = data.aws_s3_bucket.s3_destination.website_endpoint
}