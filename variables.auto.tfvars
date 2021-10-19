###########################################################
# RDS VARIABLES
###########################################################
instance_class    = "db.t3.medium"
allocated_storage = 50
db_name           = "devpostgres"
db_username       = "postgres_admin"
db_password       = "passw0rd"
db_storage_type   = "gp2"

###########################################################
# EKS VARIABLES
###########################################################
cluster_name     = "dev-api"
node_group_name  = "main-group"
instance_types   = ["t3.small"]
asg_desired_size = 3
asg_min_size     = 1
asg_max_size     = 3

###########################################################
# EC2 BASTION VARIABLES
###########################################################
bastion_name          = "dev-linux-bastion"
bastion_instance_type = "t3.small"
key_name              = "linux-ssh-key"
bastion_ami           = "ami-0a99b06fad09f48df"

###########################################################
# LOAD BALANCER VARIABLES
###########################################################
alb_name              = "dev"
alb_target_group_name = "dev-api"