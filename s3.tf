resource "aws_s3_bucket" "bucket" {
  bucket = "${local.resource_prefix}-s3-bucket-assess"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_instance_profile.ec2_profile.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}