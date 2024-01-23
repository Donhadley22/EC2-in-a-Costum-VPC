# AWS Infrastructure Deployment using Terraform

This Terraform script deploys a basic AWS infrastructure, including a Virtual Private Cloud (VPC), Internet Gateway, Route Table, Public and Private Subnets, Security Group, Network Interface, Elastic IP, and an EC2 Instance running a simple web server.

## Prerequisites

Before using this Terraform script, make sure you have the following:

- Terraform installed on your local machine.
- AWS credentials configured on your machine.

## Usage

1. Clone this repository:

   ```bash
   git clone <repository-url>
   
## Commands Used

### Change into the project directory:
- cd <project-directory>

### Initialize Terraform:
- terraform init

### Verify code
- terraform plan

### Deploy the infrastructure:
- terraform apply
Confirm the deployment by typing yes when prompted

### Destroy the infrastructure when done:
- terraform destroy
Confirm the destruction by typing yes when prompted


## Terraform Resources Created

- VPC (aws_vpc): Creates a Virtual Private Cloud with a specified CIDR block.

- Internet Gateway (aws_internet_gateway): Creates an Internet Gateway and associates it with the VPC.

- Route Table (aws_route_table): Creates a route table and adds a default route to the Internet Gateway.

- Public Subnet (aws_subnet): Creates a public subnet within the VPC.

- Private Subnet (aws_subnet): Creates a private subnet within the VPC.

- Route Table Association (aws_route_table_association): Associates the public subnet with the route table.

- Security Group (aws_security_group): Creates a security group allowing SSH, RDP, HTTP, and HTTPS traffic.

- Network Interface (aws_network_interface): Creates a network interface in the public subnet with a specified private IP and associated security group.

- Elastic IP (aws_eip): Allocates an Elastic IP address and associates it with the network interface.

- EC2 Instance (aws_instance): Launches an EC2 instance in the public subnet with a specified AMI, instance type, and user data script.


## Variables

- cidr_block: CIDR block for the VPC.
- public_subnet_cidr: CIDR block for the public subnet.
- private_subnet_cidr: CIDR block for the private subnet.
- ami: Amazon Machine Image ID for the EC2 instance.
- instance_type: EC2 instance type.
- availability_zone: Availability zone for the EC2 instance.
- key_name: Key pair name for SSH access.
- user_data: User data script for EC2 instance configuration.

