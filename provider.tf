terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.27.0"
      # configuration_aliases = [aws.crossbackup]
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
  region = "us-west-2"
}