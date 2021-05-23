variable "ingress_port" {
  default = ["80", "443", "22"]
}

#Create security group to allow http traffic on port 80
resource "aws_security_group" "web_sg" {
  name        = "web_sg_${var.app_type}"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  # This is dynamic block - this will dynamic create config block present inside the declared resource. 
  # example: Multiple ingress(inbound rule) for security group
  dynamic "ingress" {
    for_each = var.ingress_port
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web_sg_${var.app_type}"
  }
}