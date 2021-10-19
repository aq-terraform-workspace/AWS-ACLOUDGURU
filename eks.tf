module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.22.0"

  cluster_version = "1.21"
  cluster_name    = var.cluster_name
  vpc_id          = module.base_network.vpc_id
  subnets         = module.base_network.private_subnets

  # Security Group
  cluster_create_security_group = false
  cluster_security_group_id     = module.sg_eks.security_group_id

  # Worker configuration
  node_groups = {
    "${var.node_group_name}" = {
      name_prefix      = var.node_group_name
      desired_capacity = var.asg_desired_size
      max_capacity     = var.asg_max_size
      min_capaicty     = var.asg_min_size
      instance_types   = var.instance_types
      key_name         = var.key_name
    }
  }

  # Write out kubeconfig file to use with kubectl
  # To enable this, please set write_kubeconfig to true in auto.tfvars
  write_kubeconfig       = var.write_kubeconfig
  kubeconfig_output_path = var.kubeconfig_output_path
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

output "node_groups" {
  description = "Node group output"
  value       = module.eks.node_groups
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = module.eks.node_groups.resources.autoscaling_groups.name
  alb_target_group_arn   = module.alb.target_group_arns[0]
}
