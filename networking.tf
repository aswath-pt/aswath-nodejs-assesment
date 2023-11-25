module "networking" {
  source               = "./modules/networking"
  env                  = var.env
  resource_prefix      = local.resource_prefix
  vpc_cidr             = var.vpc_cidr
  subnet_cidr          = var.subnet_cidrs
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
}