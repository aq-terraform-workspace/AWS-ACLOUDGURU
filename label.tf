module "base_label" {
  source = "cloudposse/label/null"
  version = "0.25.0"

  stage     = var.stage
  delimiter = "-"

  tags = var.common_tags
}