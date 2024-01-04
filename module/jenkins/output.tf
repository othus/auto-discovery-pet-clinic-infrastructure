output "jenkins_lb" {
  value = aws_elb.jenkins_lb.dns_name
}
output "instance" {
  value = aws_instance.jenkins_server.id
}
output "jenkins_server_private_ip" {
  value = aws_instance.jenkins_server.private_ip
}