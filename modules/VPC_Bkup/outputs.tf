output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "subnets_id" {
  value = aws_subnet.subnet.id
}