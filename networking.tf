
# Create a VPC with a CIDR block
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${local.env}-VPC-${local.region}"
  }
  }

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${local.env}-IG-${local.region}"
  }
}



# Create two public subnets in different availability zones and associate them with the public route table
resource "aws_subnet" "public" {
  count             =length(var.subnet_cidr.services_subnets.public)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr.services_subnets.public[count.index]
  availability_zone = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) > 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  tags = merge(
    local.predefined-tags,
    {
      "Name"                                        = format("${local.env}-subnet-public-%s", element(data.aws_availability_zones.available.names, count.index), )
      "subnet-type"                                 = "public"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.subnet_cidr.services_subnets.private)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr.services_subnets.private[count.index]
  availability_zone = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) > 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  tags = merge(
    local.predefined-tags,
    {
      "Name"                                        = format("${local.env}-subnet-private-%s", element(data.aws_availability_zones.available.names, count.index), )
      "subnet-type"                                 = "private"
    }
  )
}

# Create an elastic IP and a NAT gateway in the first public subnet
resource "aws_eip" "my_eip" {
  vpc = true
  tags = {
    Name = "${local.env}-EIP-${local.region}"
  }
}

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.my_eip.id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "${local.env}-NATG-${local.region}"
}
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat.id
  }
  tags = merge(
    {
      "Name" = "${local.env}-RT-${local.region}-private"
      "subnet-type" = "private"
    }
  )
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = merge(
    {
      "Name" = "${local.env}-RT-${local.region}-public"
      "subnet-type" = "public"
    }
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.subnet_cidr.services_subnets.private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count = length(var.subnet_cidr.services_subnets.public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}