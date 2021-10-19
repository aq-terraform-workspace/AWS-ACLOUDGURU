module "ssh_key" {
  source = "./modules/terraform-aws-credential"
  
  type   = "ssh"
  parameter_name = "linux-ssh-private-key"
  key_name       = var.key_name
}
/* 
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.2.0"
  
  name = var.bastion_name
  ami = ""
  instance_type = var.bastion_instance_type
  key_name      = var.key_name
  monitoring    = var.enable_monitoring
} */