#Common Variables
region   = "us-east-1"
env      = "dev"
repo     = "https://github.com/aswath-pt/node-s3-upload.git"
app_path = "node-s3-upload"
app_name = "nodejs"

#Networking
vpc_cidr = "10.3.0.0/16"
subnet_cidrs = {
  services_subnets = {
    private = ["10.3.112.0/20", "10.3.128.0/20"]
    public  = ["10.3.160.0/20", "10.3.176.0/20"]
  }
}
enable_dns_hostnames = true
enable_dns_support   = true


#Compute 
instance_type                   = "t2.micro"
asg_min_size                    = 1
asg_max_size                    = 1
asg_desired_size                = 1
health_check_type               = "ELB"
drop_invalid_header_fields      = true
internal_loadbalancer           = false
load_balancer_type              = "application"
target_grp_type                 = "instance"
target_grp_port                 = "5000"
target_grp_healthcheck_path     = "/"
target_grp_healthcheck_protocol = "HTTP"
target_grp_protocol             = "HTTP"
alb_listner_port                = 443
alb_listner_protocol            = "HTTPS"
custom_domain_name              = "*.assessnode.tech"


