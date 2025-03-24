terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = var.Aws_Access_key_ID
  secret_key = var.Aws_Secret_access_key
}

# 1. Create a VPC
resource "aws_vpc" "our-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}
# Create internet Gateway
resource "aws_internet_gateway" "our-gw" {
  vpc_id = aws_vpc.our-vpc.id

  tags = {
    Name = var.internet_gateway_name
  }
}
# Create a route table
resource "aws_route_table" "our-RT" {
  vpc_id = aws_vpc.our-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.our-gw.id
  }

  tags = {
    Name = var.route_table_name
  }
}
# Create a Public Subnet
resource "aws_subnet" "Public" {
  vpc_id     = aws_vpc.our-vpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = var.public_subnet_name
  }
}
# Create a Private Subnet
resource "aws_subnet" "Private" {
  vpc_id     = aws_vpc.our-vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = var.private_subnet_name
  }
}
# Route table association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_route_table.our-RT.id
}
# Create Security Group
resource "aws_security_group" "our-SG" {
  name        = var.security_group_name
  description = "Allow SSH, RDP, HTTP & HTTPS inbound traffic"
  vpc_id      = aws_vpc.our-vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP from VPC"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["10.0.2.0/32"]
  }

ingress {
    description = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["10.0.2.0/32"]
}
    ingress {
    description = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = var.security_group_name
  }
}
# Create Network Interface
resource "aws_network_interface" "our-Int" {
  subnet_id       = aws_subnet.Public.id
  private_ips     = var.network_interface_ip
  security_groups = [aws_security_group.our-SG.id]
}
# Create Elastic IP address
resource "aws_eip" "our-eip" {
  depends_on = [aws_internet_gateway.our-gw]
  network_interface         = aws_network_interface.our-Int.id
  associate_with_private_ip = var.associate_with_private_ip
}
# Create EC2 Instance
resource "aws_instance" "webserver" {
  ami           = var.ami
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  key_name = var.key_name
  depends_on = [aws_eip.our-eip]
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.our-Int.id
    }

user_data = <<-EOF
			#!/bin/bash
			sudo su
			yum update -y
			yum install httpd -y
			systemctl restart httpd
			systemctl enable httpd
			echo "Welcome to theworld Home Page" > /var/www/html/index.html
			EOF


  tags = {
    Name = "our-webserver"
  }
}