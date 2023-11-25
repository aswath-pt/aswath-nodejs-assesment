# Generate a new key pair using the tls_private_key resource
resource "tls_private_key" "new" {
  algorithm = "RSA" # The algorithm to use for the key pair
  rsa_bits  = 4096  # The number of bits to use for the key pair
}

# Create a new key pair on AWS using the aws_key_pair resource
resource "aws_key_pair" "new" {
  key_name   = "${local.resource_prefix}-Key" # The name of the key pair on AWS
  public_key = tls_private_key.new.public_key_openssh # The public key generated by the tls_private_key resource
}

# Save the private key to a local file using the local_file resource
resource "local_file" "new" {
  filename = "${path.module}/${local.resource_prefix}-Key.pem" # The path to the local file
  content  = tls_private_key.new.private_key_pem # The private key generated by the tls_private_key resource
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${local.resource_prefix}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Create a security group for the EC2 instances
resource "aws_security_group" "ec2_sg" {
  name = "${local.resource_prefix}-ec2-sg"
  description = "Allow traffic from ALB and SSH"
  vpc_id = aws_vpc.vpc.id 

  # Allow inbound traffic from the ALB on port 8080
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Reference the ALB security group ID
  }
  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.sh.tpl")
  vars = {
    repo = var.repo
    app_path = var.app_path
  }
}

# Create a launch template for the EC2 instances
resource "aws_launch_template" "ec2_lt" {
  name = "${local.resource_prefix}-ec2-lt"
  image_id = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  key_name = aws_key_pair.new.key_name
  user_data = base64encode(
    <<EOF

EOF
)
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

# Create an auto-scaling group for the EC2 instances
resource "aws_autoscaling_group" "ec2_asg" {
  name = "${local.resource_prefix}-ec2-asg"
  min_size = 1
  max_size = 1
  desired_capacity = 1
  health_check_type = "ELB"
  launch_template {
    id = aws_launch_template.ec2_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = [for s in aws_subnet.private : s.id]
  target_group_arns = [aws_lb_target_group.ec2_tg.arn] # Reference the target group ARN
}

# Create a security group for the ALB
resource "aws_security_group" "alb_sg" {
  name = "${local.resource_prefix}-alb-sg"
  description = "Allow traffic from the internet on port 80"
  vpc_id = aws_vpc.vpc.id 

  # Allow inbound traffic from the internet on port 80
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an application load balancer
resource "aws_lb" "node_alb" {
  name = "${local.resource_prefix}-alb-sg"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [for s in aws_subnet.public : s.id]
}

# Create a target group for the ALB
resource "aws_lb_target_group" "ec2_tg" {
  name = "${local.resource_prefix}-ec2-tg"
  port = 5000
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id 
  target_type = "instance"
  health_check {
    protocol = "HTTP"
    path = "/"
    interval = 30
    timeout = 10
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

# Create a listener for the ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.node_alb.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = "arn:aws:acm:us-east-1:318403278214:certificate/02e7eb7e-9683-480a-92cd-580b091dfa0d"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ec2_tg.arn
  }
}
