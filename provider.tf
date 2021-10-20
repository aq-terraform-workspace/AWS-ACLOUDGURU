terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

provider "cloudflare" {

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
