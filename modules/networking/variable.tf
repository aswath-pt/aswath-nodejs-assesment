variable "vpc_cidr" {
  type = string
  default = "10.1.0.0/16"
}
variable "subnet_cidr" {
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