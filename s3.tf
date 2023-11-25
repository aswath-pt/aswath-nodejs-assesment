module "s3_bucket" {
  source = "./modules/s3"
  resource_prefix = local.resource_prefix
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
  enable_versioning = "Enabled"
  enable_encryption = true
  s3_access_priciple = aws_iam_role.ec2_role.arn
}
