# Create AWS Route53 and point the Cloudflare domain to these name servers
module "route53" {
  source      = "git::https://github.com/aq-terraform-modules/terraform-aws-route53.git?ref=dev"
  domain_name = "aws-${uuid()}.pierre-cardin.info"
}
output "name_servers" {
  value = module.route53.route53_name_servers
}