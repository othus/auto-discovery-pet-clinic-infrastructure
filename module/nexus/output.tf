output "nexus_ip" {
  value = aws_instance.Nexus_server.public_ip
}
output "nexus_private_ip" {
  value = aws_instance.Nexus_server.private_ip
}