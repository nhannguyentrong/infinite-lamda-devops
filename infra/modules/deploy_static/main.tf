
data "aws_s3_bucket" "s3_destination" {
  bucket = var.s3_destination
}

data "aws_codecommit_repository" "repository_name" {
  repository_name = var.repository_name
}


resource "random_string" "s3_artifacts_name" {
  length = 5
  special = false
  upper = false
}

resource "aws_s3_bucket" "s3_artifacts" {
  bucket        = "codepipeline-artifacts-${random_string.s3_artifacts_name.result}"
  force_destroy = true
  tags = var.tags
}

resource "aws_iam_role" "role_code_pipeline" {
  name = "role_code_pipeline_${var.project}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : "sts:AssumeRole",
      "Principal" : {
        "Service" : "codepipeline.amazonaws.com"
      },
      "Effect" : "Allow",
      "Sid" : ""
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "pol_codepipeline" {
  name = "policy_codepipeline_${var.project}"
  role = aws_iam_role.role_code_pipeline.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketVersioning",
            "s3:PutObject"
          ],
          "Resource" : [
            "${aws_s3_bucket.s3_artifacts.arn}",
            "${aws_s3_bucket.s3_artifacts.arn}/*",
            "${data.aws_s3_bucket.s3_destination.arn}",
            "${data.aws_s3_bucket.s3_destination.arn}/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:UploadArchive",
            "codecommit:GetUploadArchiveStatus",
            "codecommit:CancelUploadArchive"
          ],
          "Resource" :"${data.aws_codecommit_repository.repository_name.arn}"        }
      ]
    }
  )
}

resource "aws_codepipeline" "deploy_pipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.role_code_pipeline.arn

  artifact_store {
    location = aws_s3_bucket.s3_artifacts.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.repository_name
        BranchName     = var.repository_branch
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        BucketName = data.aws_s3_bucket.s3_destination.id
        Extract    = true
      }
    }
  }
}
