#IAM AND SECURITY GROUPS
# Create an IAM role and an instance profile for the EC2 instances
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${local.resource_prefix}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name               = "${local.resource_prefix}-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "policy" {
  name = "${local.resource_prefix}-ec2-role-policies"
  role = aws_iam_role.ec2_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": ["${module.s3_bucket.bucket_arn}/*"]
    },
    {
      "Effect": "Allow",
      "Action": ["ssm:StartSession"],
      "Resource": ["*"]
    },
     {
            "Sid": "KMSAllow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:GenerateDataKey"
            ],
            "Effect": "Allow",
            "Resource": "${module.s3_bucket.s3_kms}"
        }
  ]
}
EOF
}