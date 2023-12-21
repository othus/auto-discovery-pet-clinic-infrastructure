locals {
  bastion_user_data = <<-EOF
#!/bin/bash
echo "${var.privatekey}" >> /home/ec2-user/key.pem
sudo chown ec2-user:ec2-user /home/ec2-user/key.pem
chmod 400 /home/ec2-user/key.pem
sudo hostnamectl set-hostname bastion
  EOF
}