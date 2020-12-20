resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
      Name = "${var.project_name}-vpc"
      "kubernetes.io/cluster/${var.project_name}" = "shared"
      "kubernetes.io/role/external-elb" = "1"
  }
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr_block, var.cidr_newbits, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
      Name = "${var.project_name}-public-subnet-${element(var.availability_zones, count.index)}"
      "kubernetes.io/cluster/${var.project_name}" = "shared"
      "kubernetes.io/role/external-elb" = "1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
      Name = "${var.project_name}-igw"
  }
}

resource "aws_eip" "eip" {
  count = length(var.availability_zones)
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  count = length(var.availability_zones)
  subnet_id = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)

  depends_on = [aws_eip.eip]

  tags = {
      Name = "${var.project_name}-nat-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_route_table" "rt" {  
  vpc_id = aws_vpc.vpc.id

  tags = {
      Name = "${var.project_name}-public-route-table"
      "kubernetes.io/cluster/${var.project_name}" = "shared"
      "kubernetes.io/role/external-elb" = "1"
  }
}

resource "aws_route_table_association" "rtassoc" {
  count = length(var.availability_zones)
  
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.rt.id
}

resource "aws_route" "ig_gateway_route" {

  route_table_id = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}