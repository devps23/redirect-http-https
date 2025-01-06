# create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env}-vpc"
  }
}
# create subnets
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = "${var.env}-subnet"
  }
}
# peer connection between two VPC's
resource "aws_vpc_peering_connection" "vpc_peer" {
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.vpc.id
  auto_accept   = true
  tags = {
    Name = "${var.env}-peer"
  }
}
# once we create subnet by default subnet id and default route table id will be associated
# create routes in route table
# Edit the routes on default route table id to current vpc id
resource "aws_route" "source_route" {
  route_table_id            = var.default_route_table_id
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer.id
}
# Edit the routes on current vpc min route table id to default vpc id
resource "aws_route" "dest_route" {
  route_table_id            = aws_vpc.vpc.main_route_table_id
  destination_cidr_block    = var.default_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer.id
}





