#  Creating All Network Resources
resource "aws_vpc" "project_vpc" {
  cidr_block           = var.vpc_cidr_block #"10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

# Public subnet 1 resource
resource "aws_subnet" "pub_sub_1" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.pub_sub_1_cidr #"10.0.1.0/24"
  availability_zone = var.az_1

  tags = {
    Name = var.pub_sub_1
  }
}

# Public subnet 2 resource
resource "aws_subnet" "pub_sub_2" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.pub_sub_2_cidr #"10.0.2.0/24"
  availability_zone = var.az_2

  tags = {
    Name = var.pub_sub_2
  }
}

# Private subnet 1 resource
resource "aws_subnet" "prvt_sub_1" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.prvt_sub_1_cidr #"10.0.3.0/24"
  availability_zone = var.az_1

  tags = {
    Name = var.prvt_sub_1
  }
}

# Private subnet 2 resource
resource "aws_subnet" "prvt_sub_2" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.prvt_sub_2_cidr #"10.0.4.0/24"
  availability_zone = var.az_2

  tags = {
    Name = var.prvt_sub_2
  }
}

# Creating Internet Gateway resource
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
    Name = var.IGW
  }
}

# Creating NAT Gateway resource
# Creating NAT Gateway association with Public subnet 1 resource
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_sub_1.id
  tags = {
    "Name" = var.NAT
  }
}

# Creating Elastic IP resource for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.IGW]
  tags = {
    "Name" = var.eip
  }
}


# Creating Public Route Table resource
resource "aws_route_table" "PubRT" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    "Name" = var.PubRT
  }
}

# Creating Private Route Table resource
resource "aws_route_table" "PrvtRT" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = var.all_cidr
    gateway_id = aws_nat_gateway.NAT.id
  }
  tags = {
    "Name" = var.PrvtRT
  }
}

# Creating Public Subnet 1 Route Table association resource
resource "aws_route_table_association" "pub_sub_1_ass" {
  route_table_id = aws_route_table.PubRT.id
  subnet_id      = aws_subnet.pub_sub_1.id
}

# Creating Public Subnet 2 Route Table association resource
resource "aws_route_table_association" "pub_sub_2_ass" {
  route_table_id = aws_route_table.PubRT.id
  subnet_id      = aws_subnet.pub_sub_2.id
}

# Creating Private Subnet 1 Route Table association resource
resource "aws_route_table_association" "prvt_sub_1_ass" {
  route_table_id = aws_route_table.PrvtRT.id
  subnet_id      = aws_subnet.pub_sub_2.id
}

# Creating Private Subnet 2 Route Table association resource
resource "aws_route_table_association" "prvt_sub_2_ass" {
  route_table_id = aws_route_table.PrvtRT.id
  subnet_id      = aws_subnet.pub_sub_2.id
}

# Security Group resources for Bastion, Jenkins, Docker, Ansible, Sonarqube, Nexsu EC2 Instance

# Bastion & Ansible Security Group Resource
resource "aws_security_group" "Bastion_Ansible_SG" {
  name        = var.Bastion_Ansible_SG
  description = "Allow inbound SSH traffic"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description = "ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  egress {
    description = "SSH ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }
}

# Nexsu Security Group Resource
resource "aws_security_group" "Nexsu_SG" {
  name        = var.Nexsu_SG
  description = "Allow inbound SSH traffic"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description = "http proxy 1 port"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "http proxy 1 port"
    from_port   = 8085
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }
  tags = {
    "Name" = var.Nexsu_SG
  }
}

# Docker Security Group Resource
resource "aws_security_group" "Docker_SG" {
  name        = var.Docker_SG
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description = "http port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "http proxy port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "SSH port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "https port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }
  tags = {
    "Name" = var.Docker_SG
  }
}

# Jenkins Security Group Resource
resource "aws_security_group" "Jenkins_SG" {
  name        = var.Jenkins_SG
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description = "http proxy port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "http port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "http proxy port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }
  tags = {
    "Name" = var.Jenkins_SG
  }
}

# Sonarqube Security Group Resource
resource "aws_security_group" "Sonarqube_SG" {
  name        = var.Sonarqube_SG
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description = "Sonarqube port"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }
  tags = {
    "Name" = var.Sonarqube_SG
  }
}

# RDS Security Group Resource
resource "aws_security_group" "RDS_SG" {
  name        = var.RDS_SG
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.project_vpc.id

  ingress  {
    description = "mysql port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }
  tags = {
    "Name" = var.RDS_SG
  }
}

# TLS RSA Public & Private key Resource
resource "tls_private_key" "tlskey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Local Private key File of the TLS key Resource
resource "local_file" "sshkey" {
  content         = tls_private_key.tlskey.private_key_pem
  file_permission = "600"
  filename        = "tlskey.pem"
}

# AWS Keypair Resource
resource "aws_key_pair" "project_key" {
  key_name   = var.keypair_name
  public_key = tls_private_key.tlskey.public_key_openssh
}
