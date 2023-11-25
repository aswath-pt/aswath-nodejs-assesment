variable "region" {
  type    = string
  default = "us-east-1"
}
variable "env" {
  type    = string
  default = "test"
}
variable "app_name" {
  type    = string
  default = "sandbox"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "Subnet CIDR block for subnets"
  type = object({
    services_subnets = object({
      private = list(string)
      public  = list(string)
    })
  })
  default = {
    services_subnets = {
      private = ["10.0.96.0/24", "10.0.97.0/24", "10.0.98.0/24"]
      public  = ["10.0.99.0/24", "10.0.100.0/24", "10.0.101.0/24"]
    }
  }
}

variable "enable_dns_support" {
  type    = bool
  default = true
}
variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "app_path" {
  type = string
}
variable "repo" {
  type = string
}

variable "instance_type" {
  description = "The type of instance to start"
  default     = "t2.micro"
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  default     = 1
}

variable "asg_desired_size" {
  description = "Desired number of instances in the Auto Scaling Group"
  default     = 1
}

variable "health_check_type" {
  description = "Controls how health checking is done"
  default     = "ELB"
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether invalid header fields are dropped"
  default     = true
}

variable "internal_loadbalancer" {
  description = "If true, the load balancer will be internal"
  default     = true
}

variable "load_balancer_type" {
  description = "The type of load balancer to create"
  default     = "application"
}

variable "target_grp_type" {
  description = "The type of target that traffic is routed to"
  default     = "instance"
}

variable "target_grp_port" {
  description = "The port on which targets receive traffic"
  default     = "5000"
}

variable "target_grp_healthcheck_path" {
  description = "The destination for the health check request"
  default     = "/"
}

variable "target_grp_healthcheck_protocol" {
  description = "The protocol to use to connect with the target"
  default     = "HTTP"
}

variable "target_grp_protocol" {
  description = "The protocol to use to route traffic to the targets"
  default     = "HTTP"
}

variable "alb_listner_port" {
  description = "The port on which the load balancer is listening"
  default     = 443
}

variable "alb_listner_protocol" {
  description = "The protocol for connections from clients to the load balancer"
  default     = "HTTPS"
}

variable "custom_domain_name" {
  description = "Custom domain for fetching ACM certs"
  type        = string
}

variable "block_public_acls" {
    type = bool
    description = "If set to true, blocks new public ACLs and uploading public objects in the S3 bucket."
}

variable "block_public_policy" {
    type = bool
    description = "If set to true, blocks new public bucket policies for the S3 bucket."
}

variable "ignore_public_acls" {
    type = bool
    description = "If set to true, causes S3 to ignore all public ACLs on the S3 bucket and any objects that it contains."
}

variable "restrict_public_buckets" {
    type = bool
    description = "If set to true, restricts public bucket policies for the S3 bucket."
}

variable "enable_versioning" {
    description = "If set to true, enables versioning for the S3 bucket. Versioning allows you to preserve, retrieve, and restore every version of every object in your bucket."
}

variable "enable_encryption" {
    type = bool
    default = true
    description = "If set to true, enables server-side encryption for the S3 bucket using AWS S3-managed keys (SSE-S3)."
}
