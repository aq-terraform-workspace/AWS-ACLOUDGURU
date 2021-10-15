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