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