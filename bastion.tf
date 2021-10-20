module "bastion_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["bastion"]
  context    = module.base_label.context
}

module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.2.0"

  name                        = module.bastion_label.id
  ami                         = var.bastion_ami
  instance_type               = var.bastion_instance_type
  key_name                    = local.key_name
  monitoring                  = var.enable_monitoring
  vpc_security_group_ids      = [module.sg_dmz.security_group_id]
  subnet_id                   = module.base_network.public_subnets[0]
  associate_public_ip_address = var.associate_public_ip_address

  tags = module.eks_label.tags
}