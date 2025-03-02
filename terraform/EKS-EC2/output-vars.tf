output "ec2_public_ip" {
  value = aws_instance.darinterra_vm.public_ip
}
output "ec2_private_ip" {
  value = aws_instance.darinterra_vm.private_ip
}