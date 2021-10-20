variable "region" {
  description = "AWS Region"
  default = "us-east-1"
}

variable "stage" {
  description = "Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'"
  default = "dev"
}

variable "common_tags" {
  type = map(string)
  default = {
    "Managed By" = "Terraform"
  }
}

###########################################################
# RDS VARIABLES
###########################################################
variable "instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.t3.small"
}

variable "postgres_version" {
  description = "Version of the postgres DB that will be created"
  default = "13.4"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  default     = 30
}

variable "db_username" {
  description = "Username for the master DB user"
  default     = "postgres_admin"
}

variable "db_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not"
  default     = "gp2"
}

variable "db_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  default     = "passw0rd"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  default     = "Sun:00:00-Sun:03:00"
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  default     = "03:00-06:00"
}

###########################################################
# EKS VARIABLES
###########################################################
variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  default     = "1.21"
}

variable "instance_types" {
  description = "Node group's instance type(s). Multiple types can be specified when capacity_type='SPOT'"
  type = list(string)
  default = ["t3.small"]
}

variable "asg_desired_size" {
  description = "Desired number of workers"
  default = 1
}

variable "asg_max_size" {
  description = "Max number of workers"
  default = 2
}

variable "asg_min_size" {
  description = "	Min number of workers"
  default = 1
}

variable "node_group_name" {
  description = "Name of the node group"
  default = "main-group"
}

variable "write_kubeconfig" {
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to `kubeconfig_output_path`."
  type        = bool
  default     = false
}

variable "kubeconfig_output_path" {
  description = "Where to save the Kubectl config file (if `write_kubeconfig = true`)"
  default     = "./"
}

variable "max_unavailable_percentage" {
  description = "Max percentage of unavailable nodes during update. (e.g. 25, 50, etc)"
  default     = ""
}

variable "max_unavailable" {
  description = "Max number of unavailable nodes during update"
  default     = ""
}

###########################################################
# EC2 BASTION VARIABLES
###########################################################
variable "bastion_instance_type" {
  description = "Instance type of the bastion VM"
  default     = "t3.small"
}

variable "enable_monitoring" {
  description = "Enable monitoring for Bastion or not"
  type        = bool
  default     = false
}

variable "bastion_ami" {
  description = "AMI ID to create the bastion"
  default     = "ami-0a99b06fad09f48df" # Ubuntu 20.04 LTS
}

variable "associate_public_ip_address" {
  description = "Assign pubblic IP to instance or not"
  type        = bool
  default     = true
}

###########################################################
# LOAD BALANCER VARIABLES
###########################################################
variable "enable_cross_zone_load_balancing" {
  description = "Indicates whether cross zone load balancing should be enabled in application load balancers"
  type        = bool
  default     = true
}