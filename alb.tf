module "alb" {
  source      = "git::https://github.com/aq-terraform-modules/terraform-aws-alb.git?ref=dev"
  name        = "core"
}