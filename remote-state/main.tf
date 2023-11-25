provider "aws" {
  region  = var.aws_region
}
provider "aws" {
  alias   = "east2"
  region  = var.aws_region2
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.terraform_bucket_name
  force_destroy = true
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = var.terraform_dynamodb_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}