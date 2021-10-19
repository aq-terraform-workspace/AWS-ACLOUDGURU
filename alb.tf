module "alb" {
  source  = "HDE/alb/aws"
  version = "6.3.0"

  name = var.alb_name
  vpc_id = module.base_network.vpc_id
  subnets = module.base_network.public_subnets
  security_groups = [module.sg_alb.security_group_id]

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  target_groups = [
    {
      name             = "${var.alb_target_group_name}"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check     = {
        enabled = true
        
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}