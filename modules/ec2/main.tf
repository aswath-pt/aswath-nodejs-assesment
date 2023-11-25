# Generate a new key pair using the tls_private_key resource
resource "tls_private_key" "new" {
  algorithm = "RSA" # The algorithm to use for the key pair
  rsa_bits  = 4096  # The number of bits to use for the key pair
}

# Create a new key pair on AWS using the aws_key_pair resource
resource "aws_key_pair" "new" {
  key_name   = "${var.resource_prefix}-Key" # The name of the key pair on AWS
  public_key = tls_private_key.new.public_key_openssh # The public key generated by the tls_private_key resource
}

# Save the private key to a local file using the local_file resource
resource "local_file" "new" {
  filename = "${path.module}/${var.resource_prefix}-Key.pem" # The path to the local file
  content  = tls_private_key.new.private_key_pem # The private key generated by the tls_private_key resource
}

# Create a launch template for the EC2 instances
#tfsec:ignore:aws-ec2-enforce-launch-config-http-token-imds
resource "aws_launch_template" "ec2_lt" {
  name = "${var.resource_prefix}-ec2-lt"
  image_id = var.asg_ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }
  key_name = aws_key_pair.new.key_name
  user_data = base64encode(var.user_data)
  vpc_security_group_ids = var.ec2_sg_ids
}

# Create an auto-scaling group for the EC2 instances
resource "aws_autoscaling_group" "ec2_asg" {
  name = "${var.resource_prefix}-ec2-asg"
  min_size = var.asg_min_size
  max_size = var.asg_max_size
  desired_capacity = var.asg_desired_size
  health_check_type = var.health_check_type
  launch_template {
    id = aws_launch_template.ec2_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.vpc_zone_identifier
  target_group_arns = [aws_lb_target_group.ec2_tg.arn] # Reference the target group ARN
}


# Create an application load balancer
resource "aws_lb" "node_alb" {
  name = "${var.resource_prefix}-alb-sg"
  drop_invalid_header_fields = var.drop_invalid_header_fields
#tfsec:ignore:aws-elb-alb-not-public
  internal = var.internal_loadbalancer
  load_balancer_type = var.load_balancer_type
  security_groups = var.alb_sg_ids
  subnets = var.alb_subnets
}

# Create a target group for the ALB
resource "aws_lb_target_group" "ec2_tg" {
  name = "${var.resource_prefix}-ec2-tg"
  port = var.target_grp_port
  protocol = var.target_grp_protocol
  vpc_id = var.vpc_id
  target_type = var.target_grp_type
  health_check {
    protocol = var.target_grp_healthcheck_protocol
    path = var.target_grp_healthcheck_path
  }
}

# Create a listener for the ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.node_alb.arn
  port = var.alb_listner_port
  protocol = var.alb_listner_protocol
  certificate_arn = var.acm_arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ec2_tg.arn
  }
}
