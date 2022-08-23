resource "aws_kms_key" "backup-key" {
  description             = "KSM Key for Backup Vault"
  deletion_window_in_days = 10
}

resource "aws_kms_key" "crossaccount-backup-key" {
  provider                = aws.crossaccount
  description             = "KSM Key for Backup Vault"
  deletion_window_in_days = 10
}