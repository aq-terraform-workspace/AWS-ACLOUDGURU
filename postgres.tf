
module "postgres_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["postgres"]
  context    = module.base_label.context
}

module "postgres" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.4.0"

  identifier = module.postgres_label.id

  # DB instance configuration
  engine                 = "postgres"
  engine_version         = "13.4"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  vpc_security_group_ids = [module.sg_database.security_group_id]
  publicly_accessible    = false
  storage_encrypted      = false
  storage_type           = var.db_storage_type
  multi_az               = true
  name                   = module.postgres_label.id
  username               = var.db_username
  password               = var.db_password
  # Uncomment the next 2 lines to enable random password creation. Remember to comment the password var above
  # create_random_password = true
  # random_password_length = 10
  port = "5432"

  # DB subnet group
  create_db_subnet_group = false
  db_subnet_group_name   = module.base_network.database_subnet_group_name

  # Upgrade control
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  # Parameter group and option group
  create_db_option_group    = false
  create_db_parameter_group = false

  # Maintenance and backup
  maintenance_window = var.maintenance_window
  backup_window      = var.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval = "30"
  # monitoring_role_name = "MyRDSMonitoringRole"
  # create_monitoring_role = true

  # Cloudwatch log export. Enable this if cloudwatch log needed
  # enabled_cloudwatch_logs_exports = [
  #   "postgresql",
  #   "upgrade"
  # ]

  tags = module.postgres_label.tags
}