variable "vpc_cidr" {
  type = string
    default = "10.0.0.0/16"
}

variable "vpc_name" {
  type = string
  default = "our-vpc" 
}

variable "internet_gateway_name" {
  type = string
  default = "our-gw"
}

variable "route_table_name" {
  type = string
  default = "our-RT"
}

variable "public_subnet_cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "public_subnet_name" {
  type = string
  default = "Public"  
}

variable "private_subnet_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "private_subnet_name" {
  type = string
  default = "Private"  
}

variable "security_group_name" {
  type = string
  default = "our-SG"
}

variable "network_interface_ip" {
  type = list(string)
  default = ["10.0.1.50"]
}

variable "associate_with_private_ip" {
  type = string
    default = "10.0.1.50"
}

variable "ami" {
  type = string
  default = "ami-084568db4383264d4"
  
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "availability_zone" {
  type = string
    default = "us-east-1a"
}

variable "key_name" {
  type = string
    default = "Caleb-key"
}

variable "server_name" {
  type = string
    default = "webserver"
  
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "Aws_Secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}

variable "Aws_Access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}