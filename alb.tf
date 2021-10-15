module "alb" {
  source      = "git::https://github.com/aq-terraform-modules/terraform-aws-alb.git?ref=dev"
  name        = "core-${random_integer.random.result}"
  subnets     = module.base_network.public_subnets
  security_groups = [module.base_network.default_security_group_id]
}