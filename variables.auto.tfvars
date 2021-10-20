### LABEL ###
stage = "dev"

### RDS VARIABLES ###
instance_class     = "db.t3.small"
postgres_version   = "13.4"
allocated_storage  = 50
db_username        = "postgres_admin"
db_password        = "passw0rd"
db_storage_type    = "gp2"
maintenance_window = "Sun:00:00-Sun:03:00"
backup_window      = "03:00-06:00"

### EKS VARIABLES ###
cluster_version  = "1.21"
node_group_name  = "main-group"
instance_types   = ["t3.small"]
asg_desired_size = 2
asg_min_size     = 1
asg_max_size     = 2
# Use only 1 of these 2 option to control the number of nodes available during the node automatic update
# max_unavailable_percentage = 25
# max_unavailable = 1
# Write out kubeconfig file to use with kubectl. To enable this, please set uncomment this var
write_kubeconfig = false

### EC2 BASTION VARIABLES ###
bastion_instance_type = "t3.small"