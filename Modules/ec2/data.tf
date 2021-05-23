data "aws_ami" "amzlnx" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    // values = ["amzn2-ami-hvm-2.0.20210427.0-x86_64-gp2"]
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}