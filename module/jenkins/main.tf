# Creating EC2 Instance for jenkins Server

resource "aws_instance" "jenkins_server" {
  ami = var.redhat_ami
  instance_type = var.instance_type2
  vpc_security_group_ids = [var.jenkins_SG_id]
  key_name = var.keypair_name
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  user_data = local.jenkins_user_data
  tags = {
    "Name" = var.jenkins_name
  }
}

# Creating Jenkins load balancer
resource "aws_elb" "jenkins_lb" {
  name = var.elb_name
  subnets = var.subnet_id2
  security_groups = var.elb_sg
  instances = [var.elb_instance]
  cross_zone_load_balancing = false
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:8080"
    interval = 30
  }
  tags = {
    "Name" = var.elb_name
  }
}

# resource "null_resource" "default_pwd" {
#   provisioner "local-exec" {
#     command = <<-EOT
#     sudo cat /var/

#     EOT
#   }
# }