locals {
  env             = var.env
  app_name        = var.app_name
  region          = var.region
  resource_prefix = "${var.env}-${var.app_name}-${var.region}"
  predefined-tags = {
    Project = "Assesment"
    Owner   = "Aswath"
  }
}