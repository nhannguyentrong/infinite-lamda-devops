resource "aws_ecr_repository" "erc_repository" {
    name = var.erc_repository_name
}

data "local_file" "buildspec" {
  filename = "${path.module}/buildspec.yml"

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
}

resource "aws_iam_role" "role_code_build" {
  name = "role_code_build_${var.code_build_project}_${random_string.s3_artifacts_name.result}"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "codebuild.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "pol_codebuild" {
  name = "policy_codebuild_${var.code_build_project}_${random_string.s3_artifacts_name.result}"
  role = aws_iam_role.role_code_build.id

  policy = jsonencode({
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
            "${aws_s3_bucket.s3_artifacts.arn}/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:GitPull"
          ],
          "Resource" :"${data.aws_codecommit_repository.repository_name.arn}"        
        },
        {
            "Effect" : "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:PutLogEvents",
                "logs:CreateLogStream",              
                "ecr:*",
            ],
            "Resource": "*"
        }
      ]
    })
}

resource "aws_codebuild_project" "codebuild_docker_image" {
  badge_enabled  = false
  build_timeout  = 60
  name           = var.code_build_project
  queued_timeout = 480
  service_role   = aws_iam_role.role_code_build.arn

  artifacts {
    encryption_disabled    = false
    location                   = aws_s3_bucket.s3_artifacts.id
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "S3"
  }

  environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        image_pull_credentials_type = "CODEBUILD"
        privileged_mode             = true
        type                        = "LINUX_CONTAINER"
      environment_variable {
        name ="REPOSITORY_URI"
        type = "PLAINTEXT"
        value = "${aws_ecr_repository.erc_repository.repository_url}"
      }
      environment_variable {
        name ="DOCKERHUB_PASSWORD"
        type = "PLAINTEXT"
        value = "satnhanbs"
      }
      environment_variable {
        name ="DOCKERHUB_USERNAME"
        type = "PLAINTEXT"
        value = "jamecollins"
      }        
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec           = data.local_file.buildspec.content
        insecure_ssl        = true
        location            = data.aws_codecommit_repository.repository_name.clone_url_http

        type                = "CODECOMMIT"

        git_submodules_config {
            fetch_submodules = false
        }
  }
}

resource "aws_iam_role" "role_code_pipeline" {
  name = "role_code_pipeline_${var.code_build_project}"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "codepipeline.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "pol_codepipeline" {
  name = "policy_codepipeline_${var.code_build_project}_${random_string.s3_artifacts_name.result}"
  role = aws_iam_role.role_code_pipeline.id
  policy = jsonencode({
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
            "${aws_s3_bucket.s3_artifacts.arn}/*"
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
          "Resource" :"${data.aws_codecommit_repository.repository_name.arn}"        
        },
        # {
        #     "Effect" : "Allow",
        #     "Action": [
        #         "logs:CreateLogGroup",
        #         "logs:PutLogEvents",
        #         "logs:CreateLogStream",              
        #         "ecr:*",
        #     ],
        #     "Resource": "*"
        # },        
        
        
        {
            "Effect" : "Allow",
            "Action": [
              "codebuild:*"
            ],
            "Resource": "${aws_codebuild_project.codebuild_docker_image.arn}"
        }]
    })
}

resource "aws_codepipeline" "code_pipeline" {
  name = "code_pipeline_${var.code_build_project}_${random_string.s3_artifacts_name.result}"
  role_arn = aws_iam_role.role_code_pipeline.arn
  artifact_store {
    location = aws_s3_bucket.s3_artifacts.id
    type = "S3"
  }
  stage {
    name = "CheckoutSource"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = var.repository_name
        BranchName = var.branch_name
      }
    }
  }
  stage {
    name = "BuildDeployECR"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = { ProjectName = aws_codebuild_project.codebuild_docker_image.name }
    }    
  }
  
}