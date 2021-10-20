module "vpc_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["vpc"]
  context    = module.base_label.context
}

module "base_network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name             = module.vpc_label.id
  cidr             = "172.18.40.0/22"
  azs              = ["${var.region}a", "${var.region}b"]
  public_subnets   = ["172.18.40.0/25", "172.18.40.128/25"]
  private_subnets  = ["172.18.41.0/25", "172.18.41.128/25"]
  database_subnets = ["172.18.42.0/25", "172.18.42.128/25"]

  # Public subnet configuration
  create_igw = true

  # NAT Gateway Configuration
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # Database Configuration
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false
  database_subnet_group_name             = "postgres"

  # Tag for subnets that will be used for kubernetes ingress
  public_subnet_tags = {
    "kubernetes.io/cluster/${module.eks_label.id}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${module.eks_label.id}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }

  # DNS support
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []
}