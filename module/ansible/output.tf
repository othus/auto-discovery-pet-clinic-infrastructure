output "ansible_ip" {
  value = aws_instance.ansible_server.public_ip
}
output "ansible_public_ip" {
  value = aws_instance.ansible_server.private_ip
}