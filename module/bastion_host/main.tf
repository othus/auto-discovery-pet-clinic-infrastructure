resource "aws_instance" "bastion" {
  ami                         = var.ami_redhat
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.Bastion_Ansible_SG]
  subnet_id                   = var.pub_sub_1
  key_name                    = var.keypair_name
  associate_public_ip_address = true
  user_data                   = local.bastion_user_data
  tags = {
    "Name" = var.bastion_name
  }
}