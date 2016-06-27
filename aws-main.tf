# Provider: AWS

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-west-2"
}

# VPC

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# VPC Subnets

resource "aws_subnet" "public-1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private-1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"
}

# Elastic IP(s)

resource "aws_eip" "nat" {
  vpc = true
}

# Network Gateways

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public-1.id}"
}

# Build Route Tables

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }
}

resource "aws_route_table" "custom" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
}

# Route Table -> Subnet Associations

resource "aws_route_table_association" "public-1" {
  subnet_id = "${aws_subnet.public-1.id}"
  route_table_id = "${aws_route_table.custom.id}"
}

resource "aws_route_table_association" "private-1" {
  subnet_id = "${aws_subnet.private-1.id}"
  route_table_id = "${aws_route_table.main.id}"
}

# Security Groups

resource "aws_security_group" "public" {
  name = "pub-sg"
  description = "Public instance security group"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private" {
  name = "priv-sg"
  description = "Private instance security group"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
