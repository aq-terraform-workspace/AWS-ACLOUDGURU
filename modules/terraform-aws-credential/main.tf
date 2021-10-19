locals {
  public_ssh_key  = var.type == "ssh" ? tls_private_key.linux_ssh_key[0].public_key_openssh : null
  private_ssh_key = var.type == "ssh" ? tls_private_key.linux_ssh_key[0].private_key_pem : null
  random_password = var.type == "password" ? random_password.random_password[0].result : null
}

resource "random_password" "random_password" {
  count   = var.type == "password" ? 1 : 0
  length  = var.length
  special = var.special
  min_special      = 1
  min_lower        = 1
  min_numeric      = 1
  min_upper        = 1
  override_special = var.override_special
}

resource "tls_private_key" "linux_ssh_key" {
  count = var.type == "ssh" ? 1 : 0
  algorithm = "RSA"
}

# Save private key file to local
resource "local_file" "private_key" {
  count        = length(tls_private_key.linux_ssh_key)
  content      = local.private_ssh_key
  filename     = "./creds/private_ssh_key.pem"
}

resource "aws_ssm_parameter" "credential" {
  name        = var.parameter_name
  type        = "SecureString"
  value       = var.type == "password" ? random_password.random_password[0].result : tls_private_key.linux_ssh_key[0].private_key_pem
  overwrite   = true
  tags        = {
    Name = var.parameter_name
  }
  lifecycle {
    ignore_changes = [tags, value]
  }
}

resource "aws_key_pair" "linux_public_key" {
  key_name   = var.key_name
  count      = var.type == "ssh" ? 1 : 0
  public_key = tls_private_key.linux_ssh_key[0].public_key_openssh
  tags       = {
    Name = var.key_name
  }
  lifecycle {
    ignore_changes = [tags]
  }
}
