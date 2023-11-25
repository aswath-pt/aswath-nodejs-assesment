variable "vpc_cidr" {
  type = string
  default = "10.1.0.0/16"
}
variable "subnet_cidr" {
}
variable "enable_dns_support" {
  type = bool
  default = true
}
variable "enable_dns_hostnames" {
  type = bool
  default = true
}
variable "resource_prefix" {
  type = string
  default = "default"
}
variable "env" {
  type = string
  default = "sandbox"
}
variable "nat_gateway_cidr" {
  type = string
  default = "0.0.0.0/0"
}
variable "ig_gateway_cidr" {
  type = string
  default = "0.0.0.0/0"
}
variable "public_subnets_count" {
}
variable "private_subnets_count" {
}
variable "public_subnets_cidrs" {
}
variable "private_subnets_cidrs" {
}