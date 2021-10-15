variable "region" {
  description = "AWS Region"
  # Default region for acloudguru is us-east-1
  default = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}

variable "cloudflare_email" {
  description = "Cloudflare email"
}

variable "cloudflare_api_key" {
  description = "Cloudflare API Key"
}
