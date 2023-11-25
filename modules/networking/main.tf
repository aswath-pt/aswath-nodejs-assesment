data "aws_availability_zones" "available" {
}
# Create a VPC with a CIDR block
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  
  tags = {
    Name = "${var.resource_prefix}-VPC"
  }
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.resource_prefix}-IG"
  }
}


# Create two public subnets in different availability zones and associate them with the public route table
resource "aws_subnet" "public" {
  count             = var.public_subnets_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets_cidrs[count.index]
  availability_zone = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) > 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  tags = {
      "Name"        = format("${var.env}-subnet-public-%s", element(data.aws_availability_zones.available.names, count.index), )
      "subnet-type" = "public"
    }
}

resource "aws_subnet" "private" {
  count             = var.private_subnets_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets_cidrs[count.index]
  availability_zone = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) > 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  tags = {
      "Name"        = format("${var.env}-subnet-private-%s", element(data.aws_availability_zones.available.names, count.index), )
      "subnet-type" = "private"
    }
}

# Create an elastic IP and a NAT gateway in the first public subnet
resource "aws_eip" "my_eip" {
  vpc = true
  tags = {
    Name = "${var.resource_prefix}-EIP"
  }
}

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.resource_prefix}-NATG"
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = var.nat_gateway_cidr
    nat_gateway_id = aws_nat_gateway.my_nat.id
  }
  tags = merge(
    {
      "Name"        = "${var.resource_prefix}-RT-private"
      "subnet-type" = "private"
    }
  )
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.ig_gateway_cidr
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = merge(
    {
      "Name"        = "${var.resource_prefix}-RT-public"
      "subnet-type" = "public"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.subnet_cidr.services_subnets.private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_cidr.services_subnets.public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
