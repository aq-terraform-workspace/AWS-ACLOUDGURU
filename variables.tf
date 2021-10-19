variable "region" {
  description = "AWS Region"
  # Default region for acloudguru is us-east-1
  default = "us-east-1"
}

###########################################################
# RDS VARIABLES
###########################################################
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

variable "db_password" {
  description = "Password for DB"
  default     = ""
}

variable "maintenance_window" {
  description = "Weekly maintenance time"
  default     = "Sun:00:00-Sun:03:00"
}

variable "backup_window" {
  description = "Backup time"
  default     = "03:00-06:00"
}

###########################################################
# EKS VARIABLES
###########################################################
variable "cluster_name" {
  description = "EKS cluster name"
}

variable "instance_type" {
  description = "EKS worker instance type"
}

variable "asg_max_size" {
  description = "Max size of the ASG"
}

###########################################################
# EC2 BASTION VARIABLES
###########################################################
variable "bastion_name" {
  description = "Name of bastion VM"
}

variable "bastion_instance_type" {
  description = "Instance type of the bastion VM"
}