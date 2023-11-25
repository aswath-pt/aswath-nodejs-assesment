
module "compute" {
  source                          = "./modules/ec2"
  resource_prefix                 = local.resource_prefix
  vpc_id                          = module.networking.vpc_id
  instance_type                   = var.instance_type
  asg_ami_id                      = data.aws_ami.amazon_linux.id
  ec2_instance_profile_name       = aws_iam_instance_profile.ec2_profile.name
  user_data                       = data.template_file.user_data.rendered
  ec2_sg_ids                      = [aws_security_group.ec2_sg.id]
  asg_min_size                    = var.asg_min_size
  asg_max_size                    = var.asg_max_size
  asg_desired_size                = var.asg_desired_size
  health_check_type               = var.health_check_type
  vpc_zone_identifier             = flatten(module.networking.private_subnets)
  drop_invalid_header_fields      = var.drop_invalid_header_fields
  internal_loadbalancer           = var.internal_loadbalancer
  load_balancer_type              = var.load_balancer_type
  alb_sg_ids                      = [aws_security_group.alb_sg.id]
  alb_subnets                     = flatten(module.networking.public_subnets)
  target_grp_type                 = var.target_grp_type
  target_grp_port                 = var.target_grp_port
  target_grp_healthcheck_path     = var.target_grp_healthcheck_path
  target_grp_healthcheck_protocol = var.target_grp_healthcheck_protocol
  target_grp_protocol             = var.target_grp_protocol
  alb_listner_port                = var.alb_listner_port
  alb_listner_protocol            = var.alb_listner_protocol
  acm_arn                         = data.aws_acm_certificate.acm_ssl.arn
}


# Create a security group for the EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "${local.resource_prefix}-ec2-sg"
  description = "Allow traffic from ALB and SSH"
  vpc_id      = module.networking.vpc_id

  # Allow inbound traffic from the ALB on port
  ingress {
    description     = "Allow ALB to communicate with port"
    from_port       = var.target_grp_port
    to_port         = var.target_grp_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Reference the ALB security group ID
  }
  # Allow all outbound traffic
  #tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    description = "Allow all outbound communications"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create a security group for the ALB
#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group" "alb_sg" {
  name        = "${local.resource_prefix}-alb-sg"
  description = "Allow traffic from the internet on port 80"
  vpc_id      = module.networking.vpc_id
  # Allow inbound traffic from the internet on ALB
  ingress {
    description = "All traffic on ALB from outside"
    from_port   = var.alb_listner_port
    to_port     = var.alb_listner_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #tfsec:ignore:aws-ec2-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"]
  }
}