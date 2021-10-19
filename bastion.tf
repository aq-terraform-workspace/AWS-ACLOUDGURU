module "ssh_key" {
  source = "./modules/terraform-aws-credential"

  type           = "ssh"
  parameter_name = "linux-ssh-private-key"
  key_name       = var.key_name
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.2.0"

  name                   = var.bastion_name
  ami                    = var.bastion_ami
  instance_type          = var.bastion_instance_type
  key_name               = var.key_name
  monitoring             = var.enable_monitoring
  vpc_security_group_ids = [module.sg_dmz.security_group_id]
  subnet_id              = module.base_network.public_subnets[0]
}