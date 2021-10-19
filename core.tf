#################################################################################
# BASE NETWORK CREATION
#################################################################################
/* module "base_network" {
  source          = "git::https://github.com/aq-terraform-modules/terraform-aws-base-network.git?ref=dev"
  name            = "${local.vpc_name}-${random_integer.random.result}"
  cidr_block      = "172.18.40.0/22"
  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = ["172.18.40.0/25"]
  private_subnets = ["172.18.41.0/25", "172.18.41.128/25"]
  isolated_subnets = ["172.18.42.0/25", "172.18.42.128/25"]
  create_database_subnet_group = true
  database_subnet_group_name   = "${local.vpc_name}-${random_integer.random.result}-database"
} */

module "base_network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name    = "DEV"
  cidr = "172.18.40.0/22"
  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = ["172.18.40.0/25"]
  private_subnets = ["172.18.41.0/25", "172.18.41.128/25"]
  database_subnets = ["172.18.42.0/25", "172.18.42.128/25"]

  # Public subnet configuration
  create_igw = true

  # NAT Gateway Configuration
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  # Database Configuration
  create_database_subnet_group = true
  create_database_subnet_route_table = false
  create_database_internet_gateway_route = false
  database_subnet_group_name = "postgres"
}

#################################################################################
# DOMAIN CONFIGURATION
#################################################################################
# Create AWS Route53 and point the Cloudflare domain to these name servers
/* module "route53" {
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
} */

#################################################################################
# LOAD BALANCER CREATION
#################################################################################
/* module "lb" {
  source          = "git::https://github.com/aq-terraform-modules/terraform-aws-alb.git?ref=dev"
  name            = "${local.lb_name}-${random_integer.random.result}"
  subnets         = module.base_network.public_subnets
  security_groups = [module.base_network.default_security_group_id]
  vpc_id          = module.base_network.vpc_id
} */
