#  Creating All Network Resources
resource "aws_vpc" "project_vpc" {
  cidr_block       = var.vpc_cidr_block #"10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.vpc_name
  }
}

# Public subnet 1 resource
resource "aws_subnet" "pub_sub_1" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = var.pub_sub_1_cidr #"10.0.1.0/24"
  availability_zone = var.az_1

  tags = {
    Name = var.pub_sub_1
  }
}

# Public subnet 2 resource
resource "aws_subnet" "pub_sub_2" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = var.pub_sub_2_cidr #"10.0.2.0/24"
  availability_zone = var.az_2

  tags = {
    Name = var.pub_sub_2
  }
}

# Private subnet 1 resource
resource "aws_subnet" "prvt_sub_1" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = var.prvt_sub_1_cidr #"10.0.3.0/24"
  availability_zone = var.az_1

  tags = {
    Name = var.prvt_sub_1
  }
}

# Private subnet 2 resource
resource "aws_subnet" "prvt_sub_2" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = var.prvt_sub_2_cidr #"10.0.4.0/24"
  availability_zone = var.az_2

  tags = {
    Name = var.prvt_sub_2
  }
}

# Creating Internet Gateway resource
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.project_vpc
  tags = {
    Name = var.IGW
  }
}

# Creating NAT Gateway resource
# Creating NAT Gateway association with Public subnet 1 resource
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.nat_eip
  subnet_id = aws_subnet.pub_sub_1
  tags = {
    "Name" = var.NAT
  }
}

# Creating Elastic IP resource for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  depends_on = [ aws_internet_gateway.IGW ]
  tags = {
    "Name" = var.eip_name
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
  subnet_id = aws_subnet.pub_sub_1.id
}

# Creating Public Subnet 2 Route Table association resource
resource "aws_route_table_association" "pub_sub_2_ass" {
  route_table_id = aws_route_table.PubRT.id
  subnet_id = aws_subnet.pub_sub_2.id
}

# Creating Private Subnet 1 Route Table association resource
resource "aws_route_table_association" "prvt_sub_1_ass" {
  route_table_id = aws_route_table.PrvtRT.id
  subnet_id = aws_subnet.pub_sub_2.id
}

# Creating Private Subnet 2 Route Table association resource
resource "aws_route_table_association" "prvt_sub_2_ass" {
  route_table_id = aws_route_table.PrvtRT.id
  subnet_id = aws_subnet.pub_sub_2.id
}

# Security Group resources for Bastion, Jenkins, Docker, Ansible, Sonarqube, Nexsu EC2 Instance

# Bastion & Ansible Security Group Resource

# Nexsu Security Group Resource

# Docker Security Group Resource

# Jenkins Security Group Resource

# Sonarqube Security Group Resource

# RDS Security Group Resource

# TLS RSA Public & Private key Resource

# Local Private key File of the TLS key Resource

# AWS Keypair Resource
