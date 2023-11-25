module "s3_bucket" {
  source = "./modules/s3"
  resource_prefix = local.resource_prefix
  block_public_acls = var.block_public_acls
  block_public_policy = var.block_public_policy
  ignore_public_acls = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
  enable_versioning = var.enable_versioning
  enable_encryption = var.enable_encryption
  s3_access_priciple = aws_iam_role.ec2_role.arn
}
