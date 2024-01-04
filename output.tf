output "ansible_ip" {
  value = module.ansible.ansible_ip
}
output "ansible_private_ip" {
  value = module.ansible.ansible_private_ip
}
output "stage_lb_dns" {
  value = module.env_lb.stage_lb_dns
}
output "Prod_lb_dns" {
  value = module.env_lb.Prod_lb_dns
}
output "Bastion_ip" {
  value = module.Bastion.Bastion_ip
}
output "jenkins_lb" {
  value = module.Jenkins.jenkins_lb
}
output "jenkins_server_private_ip" {
  value = module.Jenkins.jenkins_server_private_ip
}
output "nexus_ip" {
  value = module.nexus.nexus_ip
}
output "nexus_private_ip" {
  value = module.nexus.nexus_private_ip
}
output "rds_endpoint" {
  value = module.rds.rds-endpoint
}
output "sonarqube_ip" {
  value = module.sonarqube.sonarqube_ip
}
output "sonarqube_private_ip" {
  value = module.sonarqube.sonarqube_private_ip
}