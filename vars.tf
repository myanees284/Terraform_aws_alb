# Declaring the region
variable "region" {
  default = "us-east-2"
  type    = string
}

# Declaring VPC CIDR range
variable "vpc_cidr_range" {
  default = "20.0.0.0/16"
  type    = string
}

# App to install on EC2
variable "app_type" {
  default = ["app_payment", "app_product"]
}

# Instance type
variable "ec2_type" {
  default = "t2.micro"
  type    = string
}