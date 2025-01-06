#  create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env}-vpc"
  }
}
# create public subnets
resource "aws_subnet" "public_subnets" {
  count         =  length(var.public_subnets)
  vpc_id        =  aws_vpc.vpc.id
  cidr_block    =  var.public_subnets[count.index]
availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.env}-public-subnet-${count.index+1}"
  }
}
# create private subnets
resource "aws_subnet" "frontend_subnets" {
  count        = length(var.frontend_subnets)
  vpc_id       = aws_vpc.vpc.id
  cidr_block   = var.frontend_subnets[count.index]
 availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env}-frontend-subnet-${count.index+1}"
  }
}
# create backend subnets
resource "aws_subnet" "backend_subnets" {
  count        = length(var.backend_subnets)
  vpc_id       = aws_vpc.vpc.id
  cidr_block   = var.backend_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env}-backend-subnet-${count.index+1}"
  }
}
# create peer connection between two vpc ids
resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.vpc.id
  auto_accept   = true
  tags = {
    Name = "${var.env}-peer"
  }
}
# create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}
# create a route table
resource "aws_route_table" "public_route_table" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.env}-public route-table-${count.index+1}"
  }
}
//create nat gateway
resource "aws_nat_gateway" "nat" {
  count = length(var.public_subnets)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags = {
    Name = "${var.env}-nat-${count.index+1}"
  }
}
  resource "aws_eip" "eip" {
    count = length(var.public_subnets)
    domain   = "vpc"
}
//create private route table
resource "aws_route_table" "frontend_route_table" {
  count = length(var.frontend_subnets)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name = "${var.env}-route-table-${count.index+1}"
  }
}
# create backend route table
resource "aws_route_table" "backend_route_table" {
  count = length(var.backend_subnets)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name = "${var.env}-route-table-${count.index+1}"
  }
}
# associate route table id to subnet id
resource "aws_route_table_association" "public-route-association" {
  count = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}
resource "aws_route_table_association" "frontend-route-association" {
  count = length(var.frontend_subnets)
  subnet_id      = aws_subnet.frontend_subnets[count.index].id
  route_table_id = aws_route_table.frontend_route_table[count.index].id
}
# associate route table to backend subnet id
resource "aws_route_table_association" "backend-route-association" {
  count = length(var.backend_subnets)
  subnet_id      = aws_subnet.backend_subnets[count.index].id
  route_table_id = aws_route_table.backend_route_table[count.index].id
}
# edit the route
resource "aws_route" "frontend_route" {
  count = length(var.frontend_subnets)
  route_table_id = aws_route_table.frontend_route_table[count.index].id
  destination_cidr_block = var.default_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
# edit backend route
resource "aws_route" "backend_route" {
  count = length(var.backend_subnets)
  route_table_id = aws_route_table.backend_route_table[count.index].id
  destination_cidr_block = var.default_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
# default edit route
resource "aws_route" "default_route" {
  count = length(var.frontend_subnets)
  route_table_id = var.default_route_table_id
  destination_cidr_block = var.frontend_subnets[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

