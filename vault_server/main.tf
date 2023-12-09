#Provider Details
provider "aws" {
  profile = var.profilename
  region  = var.aws-region
}

# # Creating Keypair Resource
# resource "aws_key_pair" "vault-keypair" {
#   key_name   = "vault-keypair"
#   public_key = file(var.path-to-key-file)
# }

# TLS RSA Public & Private key Resource
resource "tls_private_key" "vault_tlskey" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Local Private key File of the TLS key Resource
resource "local_file" "sshkey" {
  content         = tls_private_key.vault_tlskey.private_key_pem
  file_permission = "600"
  filename        = "vault_tlskey.pem"
}

# AWS Keypair Resource
resource "aws_key_pair" "Vault-keypair" {
  key_name   = var.vault-key
  public_key = tls_private_key.vault_tlskey.public_key_openssh
}

#Creating security Group for the Vault Server
resource "aws_security_group" "vault-SG" {
  name        = "vault-name"
  description = "Allow inbound ports traffic"

  ingress {
    description = "https port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "vault port"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ssh ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Vault-SG"
  }
}

#Creating EC2 instance for Vault Server

resource "aws_instance" "vault-server" {
  ami                         = var.vault-ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.vault-SG.id]
  key_name                    = aws_key_pair.Vault-keypair.key_name
  iam_instance_profile        = aws_iam_instance_profile.vault-kms-unseal.id
  associate_public_ip_address = true
  user_data = templatefile("./vault_script.sh", {
    var1 = var.aws-region,
    var2 = aws_kms_key.vault.id,
    var3 = aws_instance.vault-server.public_dns,
    var4 = var.email,
    var5 = aws_instance.vault-server.public_ip,
  })

  tags = {
    "Name" = "vault-server"
  }
}

resource "aws_kms_key" "vault" {
  description             = "vault unseal kms key"
  deletion_window_in_days = 10
  tags = {
    "Name" = "vault-kms-unseal-key"
  }
}

# data "aws_route53_zone" "vault-rout53-zone" {
#   name         = var.domain-name
#   private_zone = false
# }

# resource "aws_route53_record" "vault-rout53-record" {
#   zone_id = data.aws_route53_zone.vault-rout53-zone.id
#   name    = var.domain-name
#   type    = "A"
#   records = [aws_instance.vault-server.public_ip]
#   ttl     = 300
# }