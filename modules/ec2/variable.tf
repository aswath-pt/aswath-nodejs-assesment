variable "resource_prefix" {
  type = string
  default = "default"
}
variable "env" {
  type = string
  default = "sandbox"
}
variable "vpc_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "user_data" {
    type = string
}
variable "ec2_sg_ids" {
}
variable "asg_min_size" {
  type = number
}
variable "asg_max_size" {
  type = number
}
variable "asg_desired_size" {
  type = number
}
variable "vpc_zone_identifier" {
}
variable "health_check_type" {
  type = string
}
variable "alb_sg_ids" {
}
variable "internal_loadbalancer" {
  type = bool
}
variable "load_balancer_type" {
  type = string
}
variable "alb_subnets" {
}
variable "target_grp_port" {
  type = number
}
variable "target_grp_protocol" {
  type = string
}
variable "target_grp_type" {
  type = string
}
variable "target_grp_healthcheck_path" {
type = string
}
variable "target_grp_healthcheck_protocol" {
  type = string
}
variable "drop_invalid_header_fields" {
  type = bool
}
variable "alb_listner_port" {
  type = number
}
variable "alb_listner_protocol" {
  type = string
}
variable "ec2_instance_profile_name" {
  type = string
}
variable "acm_arn" {
}
variable "asg_ami_id" {
}