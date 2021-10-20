module "base_network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name             = "DEV"
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
    "kubernetes.io/cluster/${cluster_name}" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }
}