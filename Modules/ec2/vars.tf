# Declaring the region
variable "region" {
  default = "us-west-2"
  type    = string
}

# Declaring the instance type
variable "ec2_type" {
  default = "t2.micro"
  type    = string
}

# Declaring the AMI id
variable "web_ami" {
  default = {
    us-east-2 = "ami-077e31c4939f6a2f3",
    us-west-2 = "ami-0cf6f5c8a62fa5da6"
    us-east-1 ="ami-0d5eff06f840b45e9"
  }
  type = map(string)
}

# dummy public_subnet_ids
variable "public_subnet_ids" {
  default = "dummy"
}

# dummy vpc id
variable "vpc_id" {
  default = "dummy"
}

# App to install on EC2
variable "app_type" {
  default = "apptype"
}