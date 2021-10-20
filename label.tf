module "base_label" {
  source = "cloudposse/label/null"
  version = "0.25.0"

  stage     = var.stage
  delimiter = "-"
  labels_as_tags = ["stage", "attributes"]

  tags = var.common_tags
}