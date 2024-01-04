output "vpc_name" {
  value = aws_vpc.project_vpc.id
}
output "pub_sub_1" {
  value = aws_subnet.pub_sub_1.id
}
output "pub_sub_2" {
  value = aws_subnet.pub_sub_2.id
}
output "prvt_sub_1" {
  value = aws_subnet.prvt_sub_1.id
}
output "prvt_sub_2" {
  value = aws_subnet.prvt_sub_2.id
}
output "Bastion_Ansible_SG" {
  value = aws_security_group.Bastion_Ansible_SG.id
}
output "Nexsu_SG" {
  value = aws_security_group.Nexsu_SG.id
}
output "Docker_SG" {
  value = aws_security_group.Docker_SG.id
}
output "Jenkins_SG" {
  value = aws_security_group.Jenkins_SG.id
}
output "Sonarqube_SG" {
  value = aws_security_group.Sonarqube_SG.id
}
output "RDS_SG" {
  value = aws_security_group.RDS_SG.id
}
output "keypair_name" {
  value = aws_key_pair.project_key.key_name
}
output "keypair" {
  value = tls_private_key.tlskey.private_key_openssh
}