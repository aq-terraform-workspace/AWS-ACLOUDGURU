module "eks" {
  source = "./modules/terraform-aws-eks"

  cluster_version = var.cluster_version
  cluster_name    = var.cluster_name
  vpc_id          = module.base_network.vpc_id
  subnets         = module.base_network.private_subnets

  # Security Group
  cluster_create_security_group = false
  cluster_security_group_id     = module.sg_eks.security_group_id

  # Worker configuration
  node_groups = {
    "${var.node_group_name}" = {
      name_prefix                   = var.node_group_name
      desired_capacity              = var.asg_desired_size
      max_capacity                  = var.asg_max_size
      min_capaicty                  = var.asg_min_size
      instance_types                = var.instance_types
      key_name                      = var.key_name
      source_security_group_ids = ["${module.sg_dmz.security_group_id}"]
    }
  }

  # Write out kubeconfig file to use with kubectl
  # To enable this, please set write_kubeconfig to true in auto.tfvars
  write_kubeconfig       = var.write_kubeconfig
  kubeconfig_output_path = var.kubeconfig_output_path

  # Not to apply aws_auth
  manage_aws_auth = false
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = module.eks.node_groups["main-group"]["resources"][0]["autoscaling_groups"][0]["name"]
  alb_target_group_arn   = module.alb.target_group_arns[0]
}

output "test" {
  value = module.eks.node_groups
}