output "bastion_public_ip" {
  description = "Public IP of the bastion VM"
  value       = module.bastion.public_ip
}