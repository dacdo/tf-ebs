# Output variable definitions

output "public-vm-public-ip" {
  description = "Public IP Addressess of EC2 Instances"
  value       = aws_instance.public-vm.public_ip
}

output "public-vm-private-ip" {
  description = "Private IP Addressess of EC2 Instances"
  value       = aws_instance.public-vm.private_ip
}
