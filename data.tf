data "aws_availability_zones" "available" {
}


# Use the aws_ami data source to fetch the Amazon Linux AMI ID
data "aws_ami" "amazon_linux" {
  # Limit the search to AMIs owned by Amazon
  owners = ["amazon"]

  # Match the AMI name with a regular expression
  name_regex = "^amzn-ami-hvm.*x86_64-gp2"

  # Get the most recent AMI
  most_recent = true
}
