module "networking" {
  source               = "./modules/networking"
  env                  = var.env
  resource_prefix      = local.resource_prefix
  vpc_cidr             = var.vpc_cidr
  subnet_cidr          = var.subnet_cidrs
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  public_subnets_count = length(var.subnet_cidrs.services_subnets.public)
  public_subnets_cidrs = var.subnet_cidrs.services_subnets.public
  private_subnets_count = length(var.subnet_cidrs.services_subnets.private)
  private_subnets_cidrs = var.subnet_cidrs.services_subnets.private
}