#VPC
resource "aws_vpc" "app-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = true
  tags = {
    Name = "app-vpc"
  }
}

#Public Subnet
resource "aws_subnet" "app-subnet-public" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.10.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "app-subnet-public"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "app-gw" {
  vpc_id = aws_vpc.app-vpc.id
}

# Route Table
resource "aws_route_table" "app-route" {
  vpc_id = aws_vpc.app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-gw.id
  }
}

# Make Subnet Public
resource "aws_route_table_association" "app-public" {
  subnet_id      = aws_subnet.app-subnet-public.id
  route_table_id = aws_route_table.app-route.id
}
