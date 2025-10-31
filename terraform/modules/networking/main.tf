resource "aws_vpc" "demo-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "demo vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "main-demo-subnet" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "demo-subnet"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id
  tags = {
    Name = "demo igw"
  }
}

resource "aws_route_table" "demo-route-table" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
}

resource "aws_route_table_association" "demo-assoc" {
  route_table_id = aws_route_table.demo-route-table.id
  subnet_id      = aws_subnet.main-demo-subnet.id
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "allow internet & ssh"
  vpc_id      = aws_vpc.demo-vpc.id
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  description       = "allow ssh to instance"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.demo-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  description       = "allow http from web"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.demo-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  description       = "allow instance to internet"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.demo-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
