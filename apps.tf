#################################################################################
# DATASOURCE
#################################################################################
data "aws_lb" "core_lb" {
  name = "${local.lb_name}-${random_integer.random.result}"
  
  depends_on = [module.lb]
}

data "aws_route53_zone" "main_zone" {
  name = "${local.sub_domain}-${random_integer.random.result}.${local.main_domain}"

  depends_on = [module.route53]
}

data "aws_vpc" "core_vpc" {
  filter {
    name = "tag:Name"
    values = ["${local.vpc_name}-${random_integer.random.result}"]
  }

  depends_on = [module.base_network]
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.core_vpc.id

  filter {
    name = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_lb_listener" "http_listener" {
  load_balancer_arn = data.aws_lb.core_lb.arn
  port = 80
}


#################################################################################
# ECS APP
#################################################################################
module "monitoring_ecs" {
  source = "git::https://github.com/aq-terraform-modules/terraform-aws-ecs.git?ref=dev"
  name   = "monitoring-${random_integer.random.result}"
  frontend_cpu = 1024
  frontend_memory = 2048
  frontend_image = "docker.io/library/nginx:stable"
  frontend_port = 80
  frontend_domain = "monitoring"
  parent_domain = "${local.sub_domain}-${random_integer.random.result}.${local.main_domain}"
  subnets = data.aws_subnet_ids.public_subnets.ids
  vpc_id = data.aws_vpc.core_vpc.id
  lb_dns_name = data.aws_lb.core_lb.dns_name
  lb_zone_id = data.aws_lb.core_lb.zone_id
  route53_zone_id = data.aws_route53_zone.main_zone.zone_id
  listener_arn = data.aws_lb_listener.http_listener.arn
}