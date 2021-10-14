# Create AWS Route53 and point the Cloudflare domain to these name servers
locals {
  main_domain = "pierre-cardin.info"
  sub_domain_prefix = "aws"
}

resource "random_integer" "random" {
  min = 1
  max = 99999999
}
module "route53" {
  source      = "git::https://github.com/aq-terraform-modules/terraform-aws-route53.git?ref=dev"
  domain_name = "${local.sub_domain_prefix}-${random_integer.random.result}.${local.main_domain}"
}
output "name_servers" {
  value = module.route53.route53_name_servers
}