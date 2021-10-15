# Create AWS Route53 and point the Cloudflare domain to these name servers
module "route53" {
  providers = {
    aws        = aws
    cloudflare = cloudflare
  }

  source      = "git::https://github.com/aq-terraform-modules/terraform-aws-route53.git?ref=dev"
  main_domain = local.main_domain
  sub_domain  = "${local.sub_domain}-${random_interger.random.result}"
}