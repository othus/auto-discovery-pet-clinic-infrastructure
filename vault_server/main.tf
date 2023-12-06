#Provider Details
 provider "aws" {
  profile = var.profilename
  region = var. aws-region
}

# Creating Keypair Resource
resource "aws_key_pair" "vault-keypair" {
  key_name = "vault-keypair"
  public_key = file(path-to-key-file)
}

#Creating security Group for the Vault Server
resource "aws_security_group" "vault-SG" {
  name = "vault-name"  
  description = "Allow inbound ports traffic"

ingress {
  description = "https port"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  description = "http port"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  description = "vault port"
  from_port = 8200
  to_port = 8200
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  description = "ssh port"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

egress {
  description = "egres ports (all ports opened)"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

tags = {
  Name = Vault-SG 
}
}

#Creating EC2 instance for Vault Server

resource "aws_instance" "vault-server" {
  ami = var.vault-ami
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.vault-SG.id ]
  key_name = aws_key_pair.vault-keypair.key_name
  iam_instance_profile = aws_iam_instance_profile.vault-kms-unseal.ipv6_addresses
  associate_public_ip_address = true
  user_data = templatefile("./vault_script.sh",{
    var1 = var.aws-region,
    var2 = var.aws_kms_key.vault.id,
    var3 = var.domain-name,
    var4 = var.email
  }
  )
  tags = {
    "Name" = vault-server
  }
}
