# Resources Block
# Resource-1: Create VPC
resource "aws_vpc" "vpc-dev" {
  cidr_block = var.vpc-cidr[0]
  tags = {
    "Name" = "vpc-dev"
  }
}

# Resource-2: Public-Subnet-1
resource "aws_subnet" "vpc-dev-public-subnet-1" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = var.vpc-cidr[1]
  availability_zone       = var.availability_zone["az-1"]
  map_public_ip_on_launch = var.map-on-launch
}

# Resource-3: Public-Subnet-2
resource "aws_subnet" "vpc-dev-public-subnet-2" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = var.vpc-cidr[2]
  availability_zone       = var.availability_zone["az-2"]
  map_public_ip_on_launch = var.map-on-launch
}

# Resource-4: Private-Subnet-1
resource "aws_subnet" "vpc-dev-private-subnet-1" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = var.vpc-cidr[3]
  availability_zone       = var.availability_zone["az-1"]
  #map_public_ip_on_launch = true
}

# Resource-5: Private-Subnet-2
resource "aws_subnet" "vpc-dev-private-subnet-2" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = var.vpc-cidr[4]
  availability_zone       = var.availability_zone["az-2"]
  #map_public_ip_on_launch = var.map-on-launch
}


# Resource-6: Internet Gateway
resource "aws_internet_gateway" "vpc-dev-igw" {
  vpc_id = aws_vpc.vpc-dev.id
}

# Resource-7: Create Route Table
resource "aws_route_table" "vpc-dev-public-route-table" {
  vpc_id = aws_vpc.vpc-dev.id
  tags = {
    Name = "public-route-table"
  }
}

# Resource-8: Create Route Table
resource "aws_route_table" "vpc-dev-private-route-table" {
  vpc_id = aws_vpc.vpc-dev.id
  tags = {
    Name = "private-route-table"
  }
}

# Resource-9: Create Route in Route Table for Public Route Table
resource "aws_route" "vpc-dev-public-route" {
  route_table_id         = aws_route_table.vpc-dev-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-dev-igw.id
}

# Resource-10: Associate the Route Table with the Public-1-Subnet
resource "aws_route_table_association" "vpc-dev-public-route-table-associate-1" {
  route_table_id = aws_route_table.vpc-dev-public-route-table.id
  subnet_id      = aws_subnet.vpc-dev-public-subnet-1.id
}

# Resource-12: Associate the Route Table with the Public-2-Subnet
resource "aws_route_table_association" "vpc-dev-public-route-table-associate-2" {
  route_table_id = aws_route_table.vpc-dev-public-route-table.id
  subnet_id      = aws_subnet.vpc-dev-public-subnet-2.id
}

# Resource-6: Associate the Route Table with the Private-1-Subnet
resource "aws_route_table_association" "vpc-dev-private-route-table-associate-1" {
  route_table_id = aws_route_table.vpc-dev-private-route-table.id
  subnet_id      = aws_subnet.vpc-dev-private-subnet-1.id
}

# Resource-6: Associate the Route Table with the Private-2-Subnet
resource "aws_route_table_association" "vpc-dev-private-route-table-associate-2" {
  route_table_id = aws_route_table.vpc-dev-private-route-table.id
  subnet_id      = aws_subnet.vpc-dev-private-subnet-2.id
}

# Resource-11: Elastic IP
resource "aws_eip" "nat_gateway" {
  vpc = true
}

# Resource-12: NAT Gateway
resource "aws_nat_gateway" "dev-gw" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.vpc-dev-public-subnet-1.id

  tags = {
    Name = "public-dev-NATGW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.vpc-dev-igw]
}

# Resource-13: Create Route in Route Table for Private Route Table
resource "aws_route" "vpc-dev-private-route" {
  route_table_id         = aws_route_table.vpc-dev-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.dev-gw.id
}