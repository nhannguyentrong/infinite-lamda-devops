provider "aws" {
  region = "us-west-2"
  profile = "infinite-lamda-devops"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "infinite-terraform-tfstate"
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "app-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
