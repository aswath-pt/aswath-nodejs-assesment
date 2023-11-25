


# Use the aws_ami data source to fetch the Amazon Linux AMI ID
data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  name_regex  = "^amzn-ami-hvm.*x86_64-gp2"
  most_recent = true
}


data "template_file" "user_data" {
  template = file("${path.module}/userdata.sh.tpl")
  vars = {
    repo     = var.repo
    app_path = var.app_path
  }
}

data "aws_acm_certificate" "acm_ssl" {
  domain = var.custom_domain_name
  types  = ["AMAZON_ISSUED"]
}