locals {
  main_domain = "pierre-cardin.info"
  sub_domain  = "aws"
  lb_name     = "core"
}

# Create random number since this is for acloudguru
resource "random_integer" "random" {
  min = 1
  max = 99999999
}

module "base_network" {
  source      = "git::https://github.com/aq-terraform-modules/terraform-aws-base-network.git?ref=dev"

  cidr_block = "139.0.0.0/16"
  azs        = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["139.0.10.0/24", "139.0.11.0/24", "139.0.12.0/24"]
  private_subnets = ["139.0.20.0/24", "139.0.21.0/24", "139.0.22.0/24"]
}