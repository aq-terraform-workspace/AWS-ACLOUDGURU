module "dmz_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"

  name    = "sg_dmz"
  description = "Security group for Bastion"
  vpc_id      = module.base_network.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow SSH from Internet"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = "Allow RDP from Internet"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = "0"
      to_port     = "0"
      protocol    = "-1"
      description = "Allow all local traffic"
      cidr_blocks = module.base_network.vpc_cidr_block
      self        = true
    }
  ]
}

module "dmz_alb" {
  source = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"

  name    = "alb_dmz"
  description = "Security group for Load Balancer"
  vpc_id      = module.base_network.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow HTTP from Internet"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow HTTPS from Internet"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "eks_alb" {
  source = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"

  name    = "eks_dmz"
  description = "Security group for EKS"
  vpc_id      = module.base_network.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow HTTP from LB"
      source_security_group_id = module.dmz_alb.security_group_id
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow HTTPS from LB"
      source_security_group_id = module.dmz_alb.security_group_id
    },
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Allow Postgres"
      source_security_group_id = module.postgres_sg.security_group_id
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all from Bastion"
      source_security_group_id = module.dmz_sg.security_group_id
    }
  ]
}

module "postgres_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"

  name    = "sg_database"
  description = "Security group for Postgres"
  vpc_id      = module.base_network.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Allow Postgres from Bastion"
      source_security_group_id = module.dmz_sg.security_group_id
    },
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Allow Postgres from EKS"
      source_security_group_id = module.eks_alb.security_group_id
    }
  ]
}