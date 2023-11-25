variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "terraform_bucket_name" {
  type    = string
  default = "aswath-terraform-state"
}

variable "terraform_dynamodb_name" {
  type    = string
  default = "aswath-terraform-table"
}
 variable "multiregion" {
   type = bool  
 }
 variable "aws_region2" {
   type = string 
   default = "us-east-2"  
 }