output "bastion_public_ip" {
  description = "Public IP of the bastion VM"
  value       = module.bastion.public_ip
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = module.eks.cluster_endpoint
}

output "kubeconfig" {
  description = "kubectl config file contents for this EKS cluster. Will block on cluster creation until the cluster is really ready."
  value       = module.eks.kubeconfig
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}

output "postgres_instance_endpoint" {
  description = "The postgres connection endpoint"
  value       = module.postgres.db_instance_endpoint
}

output "postgres_instance_port" {
  description = "The postgres connection port"
  value       = module.postgres.db_instance_port
}