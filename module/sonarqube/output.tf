output "sonarqube_ip" {
  value = aws_instance.Sonarqube_server.public_ip
}
output "sonarqube_private_ip" {
  value = aws_instance.Sonarqube_server.private_ip
}