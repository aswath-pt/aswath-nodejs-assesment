region   = "us-east-2"
env      = "dev"
vpc_cidr = "10.5.0.0/16"
subnet_cidr = {
  services_subnets = {
    private = ["10.5.112.0/20", "10.5.128.0/20"]
    public  = ["10.5.160.0/20", "10.5.176.0/20"]
  }
}

repo     = "https://github.com/aswath-pt/node-js-sample.git"
app_path = "node-js-sample"
