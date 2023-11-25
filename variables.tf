variable "region" {
  type = string
  default = "us-east-1"
}
variable "env" {
    type = string
    default = "test"
}
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
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

variable "instance_type" {
    type = string
    default = "t2.micro"
}