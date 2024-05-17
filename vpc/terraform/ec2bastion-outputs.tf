
output "ec2bastion_public_instance_ids" {
  description = "List of IDs of intances"
  value       = module.ec2bastion.id
}

output "ec2bastion_eip" {
  description = "Elastic IP associated to the Bastion Host"
  value       = aws_eip.bastion_eip.public_ip
}