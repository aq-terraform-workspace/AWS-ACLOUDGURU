/* module "alb" {
  source      = "git::https://github.com/aq-terraform-modules/terraform-aws-alb.git?ref=dev"
  name        = "core-${random_integer.random.result}"
  subnets     = module.base_network.public_subnets
} */