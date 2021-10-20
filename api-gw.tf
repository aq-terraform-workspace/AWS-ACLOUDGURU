module "apigw_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["apigw"]
  context    = module.base_label.context
}


module "apigateway-v2" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "1.4.0"

  name          = module.apigw_label.id
  description   = "API Gateway for ${module.apigw_label.stage}"
  protocol_type = "HTTP"
  target        = "http://${module.alb.lb_dns_name}"

  create_api_domain_name           = false
  create_routes_and_integrations   = false
  create_vpc_link                  = false
  create_default_stage             = false
  create_default_stage_api_mapping = false

  tags = module.apigw_label.tags
}