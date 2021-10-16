locals {
  main_domain = "pierre-cardin.info"
  sub_domain  = "aws"
  lb_name     = "core"
  vpc_name    = "core"
  monitoring_frontend_cpu = 1024
  monitoring_frontend_memory = 2048
  monitoring_frontend_port = 80
  monitoring_frontend_domain = "monitoring"
  monitoring_frontend_log_group_name_prefix = "ecs"
  monitoring_frontend_image = "docker.io/sheid1309/simple-nodejs"
}

# Create random number since this is for acloudguru
resource "random_integer" "random" {
  min = 1
  max = 99999999
}