#tfsec:ignore:aws-s3-block-public-acls
#tfsec:ignore:aws-s3-block-public-policy
#tfsec:ignore:aws-s3-encryption-customer-key
#tfsec:ignore:aws-s3-no-public-buckets
#tfsec:ignore:aws-s3-ignore-public-acls
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-specify-public-access-block
resource "aws_s3_bucket" "bucket" {
  bucket = "${local.resource_prefix}-s3-bucket-assess"
  acl    = "private"
  versioning {
    enabled = true
  }
}


resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_instance_profile.ec2_profile.arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}