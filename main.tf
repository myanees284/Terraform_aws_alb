#provider tells terraform which cloud provider to use
provider "aws" {
  region = var.region
}

module "my_network" {
  source   = "./Modules/networking/"
  vpc_cidr = var.vpc_cidr_range
  region   = var.region
}

module "my_ec2" {
  for_each          = toset(var.app_type)
  source            = "./Modules/ec2/"
  public_subnet_ids = module.my_network.public_subnet_ids
  vpc_id            = module.my_network.vpc_id
  ec2_type          = var.ec2_type
  app_type          = each.value
  region            = var.region
}

# ALB creation
resource "aws_lb" "devalb" {
  name               = "devalb"
  internal           = false
  load_balancer_type = "application"
  #resuing the security group which was created as part of ec2 instance.
  security_groups    = [module.my_ec2[var.app_type[0]].security_group_id[0]]
  subnets            = module.my_network.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Environment = "${terraform.workspace}_ALB"
  }
}

# ALB target group creation
resource "aws_lb_target_group" "tgp" {
  name     = "tgp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.my_network.vpc_id
}

# ALB listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.devalb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgp.arn
  }
}

# ALB listener rule to route incoming traffic routes /payment/ and /product/
resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgp.arn
  }

  condition {
    path_pattern {
      values = ["/payment/*", "/product/*"]
    }
  }
}

# ALB target group attchment to attach EC2 instances running PRODUCT app
resource "aws_lb_target_group_attachment" "tga1" {
  count            = length(module.my_ec2["app_product"].ec2_instance_ids)
  target_group_arn = aws_lb_target_group.tgp.arn
  target_id        = module.my_ec2["app_product"].ec2_instance_ids[count.index]
  port             = 80
}

# ALB target group attchment to attach EC2 instances running PAYMENT app
resource "aws_lb_target_group_attachment" "tga2" {
  count            = length(module.my_ec2["app_payment"].ec2_instance_ids)
  target_group_arn = aws_lb_target_group.tgp.arn
  target_id        = module.my_ec2["app_payment"].ec2_instance_ids[count.index]
  port             = 80
}


# Attempt to create ALB single Target Group Attachment to repeat through 2 different app type (PAYMENT and PRODUCT). Not working.
// resource "aws_lb_target_group_attachment" "tga" {
//   for_each = toset(var.app_type)
//   // count            = length(module.my_ec2["app_product"].ec2_instance_ids)
//   target_group_arn = aws_lb_target_group.tgp.arn
//   target_id        = module.my_ec2[each.value].ec2_instance_ids[1]
//   port             = 80
// }
