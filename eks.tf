module "eks_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["eks"]
  context    = module.base_label.context
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.22.0"

  cluster_version = var.cluster_version
  cluster_name    = module.eks_label.id
  vpc_id          = module.base_network.vpc_id
  subnets         = module.base_network.private_subnets
  enable_irsa     = true

  # Security Group
  cluster_create_security_group = false
  cluster_security_group_id     = module.sg_eks.security_group_id

  # Worker configuration
  node_groups = [
    {
      name_prefix               = var.node_group_name
      desired_capacity          = var.asg_desired_size
      max_capacity              = var.asg_max_size
      min_capaicty              = var.asg_min_size
      instance_types            = var.instance_types
      key_name                  = local.key_name
      source_security_group_ids = ["${module.sg_dmz.security_group_id}"]
      # Use only 1 of these 2 option to control the number of nodes available during the node automatic update
      # update_config.max_unavailable_percentage = var.max_unavailable_percentage
      # update_config.max_unavailable            = var.max_unavailable
      additional_tags           = {
        "k8s.io/cluster-autoscaler/enabled" = "true"
        "k8s.io/cluster-autoscaler/${module.eks_label.id}" = "owned"
      }
    }
  ]

  # Write out kubeconfig file to use with kubectl. To enable this, please set write_kubeconfig to true in auto.tfvars and uncomment these 2 lines
  write_kubeconfig       = var.write_kubeconfig
  kubeconfig_output_path = var.kubeconfig_output_path

  # Not to apply aws_auth
  manage_aws_auth = false

  tags = module.eks_label.tags
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = module.eks.node_groups[0]["resources"][0]["autoscaling_groups"][0]["name"]
  alb_target_group_arn   = module.alb.target_group_arns[0]
}

resource "aws_security_group_rule" "additional_node_rule" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.sg_alb.security_group_id
  description              = "Allow all traffic from LB to node"
  security_group_id        = module.eks.node_groups[0]["remote_access"][0]["source_security_group_ids"][0]
}

output "test" {
  value = module.eks.node_groups
}