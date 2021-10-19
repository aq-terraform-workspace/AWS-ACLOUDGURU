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

variable "db_name" {
  description = "DB name"
}

variable "db_username" {
  description = "DB Username"
}

variable "db_storage_type" {
  description = "Storage type for DB"
  default     = "gp2"
}