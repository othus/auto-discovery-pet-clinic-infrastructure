output "jenkins_ip" {
  value = aws_elb.jenkins_lb.dns_name
}
output "instance" {
  value = aws_instance.jenkins_server.id
}