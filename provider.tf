terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.27.0"
      configuration_aliases = [ aws.crossbackup ]
    }
  }
  required_version = ">=0.15.5"
}

provider "aws" {
  region = "us-east-1"
}

# Additional provider configuration for west coast region; resources can
# reference this as `aws.west`.
provider "aws" {
  alias  = "crossbackup"
  region = "us-east-2"

  ## Method 1: Using access and secret key to authen to destination account
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"

  ## Method 2: Using AWS Profile to authen to destination account
  # profile = "crossbackup"

  ## Method 3: Using assume role to destination account
  # assume_role {
  #   role_arn = "arn:aws:iam::############:role/Admin"
  # }
}