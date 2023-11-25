variable "resource_prefix" {
  type = string
  default = "default"
}
variable "env" {
  type = string
  default = "sandbox"
}
variable "block_public_acls" {
    type = bool
}
variable "block_public_policy" {
    type = bool
}
variable "ignore_public_acls" {
    type = bool
}
variable "restrict_public_buckets" {
    type = bool
}
variable "enable_versioning" {
}
variable "enable_encryption" {
  type = bool
  default = true
}
variable "s3_access_priciple" {
}