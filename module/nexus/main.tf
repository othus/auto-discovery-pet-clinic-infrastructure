# Creating EC2 Instance for Nexus Server

resource "aws_instance" "Nexus_server" {
  ami = var.redhat_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [var.Nexus_SG]
  key_name = var.keypair_name
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  user_data = local.nexus_user_data
  tags = {
    "Name" = var.nexus_name
  }
}