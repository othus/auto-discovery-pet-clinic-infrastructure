# Creating EC2 Instance for Sonarqube Server

resource "aws_instance" "Sonarqube_server" {
  ami                         = var.ubuntu_ami
  instance_type               = var.instance_type2
  vpc_security_group_ids      = [var.Sonarqube_SG]
  key_name                    = var.keypair_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  user_data                   = local.sonarqube_user_data
  tags = {
    "Name" = var.sonarqube_name
  }
}