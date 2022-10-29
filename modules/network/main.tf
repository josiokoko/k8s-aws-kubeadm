terraform {
  required_version = ">= 0.12"
}


locals {
  az_names = var.aws_availability_zones
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags       = var.tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags
}

resource "aws_subnet" "main" {
  count             = length(local.az_names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + 1)
  availability_zone = local.az_names[count.index]
  tags              = var.tags
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = var.tags
}

resource "aws_route_table_association" "main" {
  count          = length(local.az_names)
  route_table_id = aws_route_table.main.id
  subnet_id      = aws_subnet.main.*.id[count.index]
}