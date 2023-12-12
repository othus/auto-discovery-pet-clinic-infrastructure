# Create EC" Instance for Ansible node
resource "aws_instance" "ansible_server" {
  ami = var.ami_redhat
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [ var.ansible_SG ]
  key_name = var.keypair_name
  associate_public_ip_address = true
  user_data = local.ansible_user_data
  tags = {
    "Name" = var.ansible_name
  }
}