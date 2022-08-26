# Setting for source AWS Backup
resource "aws_backup_global_settings" "source" {
	global_settings = {
		"isCrossAccountBackupEnabled" = "true"
	}
}

resource "aws_backup_region_settings" "source" {
	resource_type_opt_in_preference = {
		"Aurora"          = true
		"DocumentDB"      = true
		"DynamoDB"        = true
		"EBS"             = true
		"EC2"             = true
		"EFS"             = true
		"FSx"             = true
		"Neptune"         = true
		"RDS"             = true
		"Storage Gateway" = true
		"VirtualMachine"  = true
	}

	resource_type_management_preference = {
		"DynamoDB" = true
		"EFS"      = true
	}
}

# Setting for destination AWS Backup
resource "aws_backup_global_settings" "dest" {
	provider = aws.crossbackup
	global_settings = {
		"isCrossAccountBackupEnabled" = "true"
	}
}

resource "aws_backup_region_settings" "dest" {
	provider = aws.crossbackup
	resource_type_opt_in_preference = {
		"Aurora"          = true
		"DocumentDB"      = true
		"DynamoDB"        = true
		"EBS"             = true
		"EC2"             = true
		"EFS"             = true
		"FSx"             = true
		"Neptune"         = true
		"RDS"             = true
		"Storage Gateway" = true
		"VirtualMachine"  = true
	}

	resource_type_management_preference = {
		"DynamoDB" = true
		"EFS"      = true
	}
}

# AWS Backup vault
resource "aws_backup_vault" "backup-vault" {
	name = "some-backup-vault-name"
	kms_key_arn = aws_kms_key.backup-key.arn
	tags = {
		Type = "my-test-backup"
	}
	depends_on = [
		aws_backup_global_settings.source,
		aws_backup_region_settings.source
	]
}

# Cross Account backup vault
resource "aws_backup_vault" "diff-account-vault" {
	provider = aws.crossbackup
	name = "some-cross-account-vault-name"
	kms_key_arn = aws_kms_key.crossbackup-backup-key.arn
	depends_on = [
		aws_backup_global_settings.dest,
		aws_backup_region_settings.dest
	]
}

# AWS Backup plan
resource "aws_backup_plan" "backup-plan" {
	name = "some-backup-plan-name"
	rule {
		rule_name = "some-backup-plan-rule-name"
		target_vault_name = aws_backup_vault.backup-vault.name
		schedule = "cron(0 5/1 ? * * *)"     #adjust the time 
		start_window = 60
		completion_window = 180
		recovery_point_tags = {
			Type = "my-test-backup"
		}
		copy_action {
			destination_vault_arn = aws_backup_vault.diff-account-vault.arn 
		}
	}
}

# AWS Backup selection with tags
resource "aws_backup_selection" "backup-selection" {
	name = "some-backup-selection-name"
	iam_role_arn = aws_iam_role.aws-backup-service-role.arn
	plan_id = aws_backup_plan.backup-plan.id
	selection_tag {
		type = var.selection-type
		key = "Type"
		value = "my-test-backup"
	}
}

resource "aws_backup_vault_policy" "organization-level-policy" {
   backup_vault_name = aws_backup_vault.backup-vault.name

   policy = <<POLICY
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":"backup:CopyIntoBackupVault",
         "Resource":"${aws_backup_vault.backup-vault.arn}",
         "Principal":"*",
         "Condition":{
            "StringEquals":{
               "aws:PrincipalOrgID":[
                  "o-plrr09k3n0"
               ]
            }
         }
      }
   ]
}
POLICY
}

# Cross Account backup policy, Organization level
resource "aws_backup_vault_policy" "organization-policy" {
   provider = aws.crossbackup
   backup_vault_name = aws_backup_vault.diff-account-vault.name
   
   policy = <<POLICY
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":"backup:CopyIntoBackupVault",
        "Resource":"*",
         "Principal":"*",
         "Condition":{
            "StringEquals":{
               "aws:PrincipalOrgID":[
                  "o-plrr09k3n0"
               ]
            }
         }
      }
   ]
}
POLICY
}