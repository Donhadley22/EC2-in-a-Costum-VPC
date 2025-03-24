output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.our-vpc.id
}

output "subnet_ids" {
    description = "The IDs of the subnets"
    value       = aws_subnet.Public.id
}

output "security_group_id" {
    description = "The ID of the security group"
    value       = aws_security_group.our-SG.id
}

output "ec2_instance_id" {
    description = "The ID of the EC2 instance"
    value       = aws_instance.webserver.id
}

output "ec2_instance_public_ip" {
    description = "The public IP of the EC2 instance"
    value       = aws_instance.webserver.public_ip
}