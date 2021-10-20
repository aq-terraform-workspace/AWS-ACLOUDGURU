locals {
  key_name = module.keypair_label.id
  parameter_name = "${module.keypair_label.id}-private-key"
}

module "keypair_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["keypair"]
  context    = module.base_label.context
}

module "ssh_key" {
  source = "./modules/terraform-aws-credential"

  type           = "ssh"
  parameter_name = local.parameter_name
  key_name       = local.key_name
  tags           = module.keypair_label.tags
}