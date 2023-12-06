# Vault server ip address output
output "Vault_IP" {
  value = aws_instance.vault-server.private_ip
}