# 1. Create a VPC
resource "aws_vpc" "our-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "our-vpc"
  }
}
# Create internet Gateway
resource "aws_internet_gateway" "our-gw" {
  vpc_id = aws_vpc.our-vpc.id

  tags = {
    Name = "our-gw"
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
    Name = "our-RT"
  }
}
# Create a Public Subnet
resource "aws_subnet" "Public" {
  vpc_id     = aws_vpc.our-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public"
  }
}
# Create a Private Subnet
resource "aws_subnet" "Private" {
  vpc_id     = aws_vpc.our-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private"
  }
}
# Route table association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_route_table.our-RT.id
}
# Create Security Group
resource "aws_security_group" "our-SG" {
  name        = "our-SG"
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
    Name = "our-SG"
  }
}
# Create Network Interface
resource "aws_network_interface" "our-Int" {
  subnet_id       = aws_subnet.Public.id
  private_ips     = ["10.0.1.20"]
  security_groups = [aws_security_group.our-SG.id]
}
# Create Elastic IP address
resource "aws_eip" "our-eip" {
  vpc                       = true
  network_interface         = aws_network_interface.our-Int.id
  associate_with_private_ip = "10.0.1.20"
}
# Create EC2 Instance
resource "aws_instance" "webserver" {
  ami           = "ami-084e8c05825742534"
  instance_type = "t2.micro"
  availability_zone = "eu-west-2a"
  key_name = "Proj1-KP"
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