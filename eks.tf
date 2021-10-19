module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.22.0"

  cluster_version = "1.21"
  cluster_name    = var.cluster_name
  vpc_id          = module.base_network.vpc_id
  subnets         = module.base_network.private_subnets

  # Security Group
  cluster_create_security_group = false
  cluster_security_group_id = module.sg_eks.security_group_id

  # Worker configuration
  worker_groups = [
    {
      instance_type = "${var.instance_type}"
      asg_max_size  = "${var.asg_max_size}"
    }
  ]
  worker_security_group_id = module.sg_eks.security_group_id
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}