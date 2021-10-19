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
cluster_name      = "dev-eks"
instance_type     = ""