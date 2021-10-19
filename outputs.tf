output "database_password" {
  description = "Output the DB password"
  value = module.postgres.db_instance_password
}