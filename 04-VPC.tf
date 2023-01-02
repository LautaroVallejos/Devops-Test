# VPC Configure
resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "DevOps VPC"
  }
}

# Subnet Settings
resource "aws_subnet" "server_subnet" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone

  tags = {
    Name = "DevOps Subnet"
  }
}

# Internet Gateway setting
resource "aws_internet_gateway" "internet_door" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "Internet Door"
  }
}

# Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.devops_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_door.id
  }
  
  tags = {
    Name = "Route Table"
  }
}

# Route Association
resource "aws_route_table_association" "table_association" {
  subnet_id      = aws_subnet.server_subnet.id
  route_table_id = aws_route_table.route_table.id
}

# Security Group
resource "aws_security_group" "firewall" {
  vpc_id = aws_vpc.devops_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}