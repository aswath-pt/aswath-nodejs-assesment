output "bucket_id" {
  value = aws_s3_bucket.bucket.id
}
output "s3_kms" {
  value = aws_kms_key.mykey[0].arn
}