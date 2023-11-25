region = "us-east-1"
env = "sandbox"
vpc_cidr         = "10.3.0.0/16"
subnet_cidr = {
  services_subnets = {
    private = ["10.3.112.0/20", "10.3.128.0/20"]
    public  = ["10.3.160.0/20", "10.3.176.0/20"]
  }
}


