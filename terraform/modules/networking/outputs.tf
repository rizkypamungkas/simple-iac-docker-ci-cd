output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.demo-vpc.id
}

output "subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.main-demo-subnet.id
}

output "route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.demo-route-table.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.demo-igw.id
}

output "sg_id" {
  description = "The ID of the security group"
  value       = aws_security_group.demo-sg.id
}
