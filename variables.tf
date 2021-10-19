variable "region" {
  description = "AWS Region"
  # Default region for acloudguru is us-east-1
  default = "us-east-1"
}

variable "instance_class" {
  description = "Instance class for RDS"
}

variable "allocated_storage" {
  description = "RDS allocated storage"
}