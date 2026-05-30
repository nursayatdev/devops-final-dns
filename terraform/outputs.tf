# Output variables for infrastructure verification and Ansible configuration

output "bastion_public_ip" {
  description = "The public IP address of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "The private internal IP address of the Bastion Host"
  value       = aws_instance.bastion.private_ip
}

output "ns1_private_ip" {
  description = "The private IP address of Primary DNS server (ns1)"
  value       = aws_instance.ns1.private_ip
}

output "ns2_private_ip" {
  description = "The private IP address of Secondary DNS server (ns2)"
  value       = aws_instance.ns2.private_ip
}

output "host1_private_ip" {
  description = "The private IP address of Host Client 1"
  value       = aws_instance.host1.private_ip
}

output "host2_private_ip" {
  description = "The private IP address of Host Client 2"
  value       = aws_instance.host2.private_ip
}
