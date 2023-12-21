# Vault server ip address output
output "Vault_IP" {
  value = aws_instance.vault-server.public_ip
}
output "Vault_private_IP" {
  value = aws_instance.vault-server.private_ip
}

output "Vault_DNS" {
  value = aws_instance.vault-server.public_dns
}