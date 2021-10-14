# Create AWS Route53 and point the Cloudflare domain to these name servers
resource "random_integer" "random" {
  min = 1
  max = 99999999
}
module "route53" {
  providers = {
    aws        = aws
    cloudflare = cloudflare
  }

  source      = "git::https://github.com/aq-terraform-modules/terraform-aws-route53.git?ref=dev"
  domain_name = "${local.sub_domain_prefix}-${random_integer.random.result}.${local.main_domain}"
}