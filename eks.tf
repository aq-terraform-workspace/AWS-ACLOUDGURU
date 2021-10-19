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
      instance_type = var.instance_type
      asg_max_size  = 5
    }
  ]
  worker_security_group_id = module.sg_eks.security_group_id


}