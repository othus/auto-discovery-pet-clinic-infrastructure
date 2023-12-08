#Provider Details
provider "aws" {
  profile = var.profilename
  region  = var.aws-region
}

# Creating Keypair Resource
resource "aws_key_pair" "vault-keypair" {
  key_name   = "vault-keypair"
  public_key = file(var.path-to-key-file)
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
  key_name                    = aws_key_pair.vault-keypair.key_name
  iam_instance_profile        = aws_iam_instance_profile.vault-kms-unseal.id
  associate_public_ip_address = true
  user_data = templatefile("./vault_script.sh", {
    var1 = var.aws-region,
    var2 = var.vault-kms-key
    var3 = var.domain-name,
    var4 = var.email
  })

  tags = {
    "Name" = "vault-server"
  }
}

resource "aws_kms_key" "vault-kms-key" {
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