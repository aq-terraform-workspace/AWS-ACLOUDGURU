module "sg_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["sg"]
  labels_as_tags = []
  context    = module.base_label.context
}

module "sg_dmz" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"

  name        = "${module.sg_label.id}-dmz"
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
      description = "Allow traffic from Local"
      cidr_blocks = module.base_network.vpc_cidr_block
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow Output to All"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = module.sg_label.tags
}

module "sg_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"

  name        = "${module.sg_label.id}-alb"
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

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow Output to All"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = module.sg_label.tags
}

module "sg_eks" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"

  name        = "${module.sg_label.id}-eks"
  description = "Security group for EKS"
  vpc_id      = module.base_network.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "tcp"
      description              = "Allow all traffic from LB"
      source_security_group_id = module.sg_alb.security_group_id
    },
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "tcp"
      description              = "Allow all traffic from LB"
      source_security_group_id = module.sg_dmz.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow output to Local"
      cidr_blocks = module.base_network.vpc_cidr_block
    }
  ]

  tags = module.sg_label.tags
}

module "sg_database" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"

  name        = "${module.sg_label.id}-database"
  description = "Security group for Database"
  vpc_id      = module.base_network.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "Allow 5432 only from Bastion for troubleshooting"
      source_security_group_id = module.sg_dmz.security_group_id
    },
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "Allow 5432 only from EKS"
      source_security_group_id = module.sg_eks.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow output to Local"
      cidr_blocks = module.base_network.vpc_cidr_block
    }
  ]

  tags = module.sg_label.tags
}