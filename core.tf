#################################################################################
# BASE NETWORK CREATION
#################################################################################
module "base_network" {
  source          = "git::https://github.com/aq-terraform-modules/terraform-aws-base-network.git?ref=dev"
  name            = "${local.vpc_name}-${random_integer.random.result}"
  cidr_block      = "139.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["139.0.10.0/24", "139.0.11.0/24", "139.0.12.0/24"]
  private_subnets = ["139.0.20.0/24", "139.0.21.0/24", "139.0.22.0/24"]
}

#################################################################################
# DOMAIN CONFIGURATION
#################################################################################
# Create AWS Route53 and point the Cloudflare domain to these name servers
module "route53" {
  source      = "git::https://github.com/aq-terraform-modules/terraform-aws-route53.git?ref=dev"
  main_domain = local.main_domain
  sub_domain  = "${local.sub_domain}-${random_integer.random.result}"
}

module "cloudflare_records" {
  providers = {
    cloudflare = cloudflare
  }

  source       = "git::https://github.com/aq-terraform-modules/terraform-cloudflare-general.git?ref=dev"
  main_domain  = local.main_domain
  sub_domain   = "${local.sub_domain}-${random_integer.random.result}"
  name_servers = module.route53.name_servers

  depends_on = [module.route53]
}

#################################################################################
# LOAD BALANCER CREATION
#################################################################################
module "lb" {
  source          = "git::https://github.com/aq-terraform-modules/terraform-aws-alb.git?ref=dev"
  name            = "${local.lb_name}-${random_integer.random.result}"
  subnets         = module.base_network.public_subnets
  security_groups = [module.base_network.default_security_group_id]
}
