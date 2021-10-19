module "postgres" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.4.0"

  identifier = var.db_name

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
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  create_random_password = true
  random_password_length = 10
  port                   = "5432"

  # DB subnet group
  create_db_subnet_group = false
  db_subnet_group_name   = module.base_network.database_subnet_group_name

  # Upgrade control
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  # Parameter group and option group
  create_db_option_group    = false
  create_db_parameter_group = false
}