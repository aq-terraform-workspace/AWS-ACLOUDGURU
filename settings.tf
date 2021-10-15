terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  acces_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "cloudflare" {
  email = var.cloudflare_email
  api_key = var.cloudflare_api_key
}


terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "aq-tf-cloud"

    workspaces {
      name = "AWS-ACLOUDGURU"
    }
  }
}
