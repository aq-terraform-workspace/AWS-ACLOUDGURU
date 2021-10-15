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