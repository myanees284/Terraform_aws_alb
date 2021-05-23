#Launch EC2 instance and host a website on it.
resource "aws_instance" "web" {
  count                       = length(var.public_subnet_ids)
  // ami                         = lookup(var.web_ami, var.region)
  ami                         = data.aws_ami.amzlnx.id
  instance_type               = var.ec2_type
  subnet_id                   = var.public_subnet_ids[count.index]
  associate_public_ip_address = true
  #security group value hardcoded as 0(payment app) intentionally because the inbound rule for product and payment apps are same.
  vpc_security_group_ids      = [local.security_group_id[0]]
  user_data                   = file("scripts/${var.app_type}.sh")

  tags = {
    Name = "${terraform.workspace}_${var.app_type}_${count.index+1}"
  }
}