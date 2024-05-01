
# Create a new Custom VPC

resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames
  tags                 = var.vpc_tags
}

# Create an internet gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = var.igw_tags
}

# Create 2 Public and 2 Private Subnets

# Create 1st public subnet
resource "aws_subnet" "pub_one" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.pub_one_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = var.public_ip_launch

  tags = {
    Name = "Pub Subnet One"
  }
}


# Create 2nd public subnet
resource "aws_subnet" "pub_two" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.pub_two_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = var.public_ip_launch

  tags = {
    Name = "Pub Subnet two"
  }
}

# Create 1st private subnet
resource "aws_subnet" "priv_one" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.priv_one_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "Private Subnet one"
  }
}

# Create 2nd private subnet
resource "aws_subnet" "priv_two" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.priv_two_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "Private Subnet two"
  }
}


# Create 1st public subnet
#resource "aws_subnet" "pub_one" {
#  vpc_id                  = aws_vpc.eks_vpc.id
#  cidr_block              = var.pub_one_cidr
#  availability_zone       = data.aws_availability_zones.available_zones.names[0]
#  map_public_ip_on_launch = var.public_ip_launch
#  tags = {
#    Name = "Pub Subnet One"
#  }
#}

#resource "aws_subnet" "public_subnets" {
#  count             = 2
#  vpc_id            = aws_vpc.eks_vpc.id
#  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
# availability_zone = data.aws_availability_zones.available_zones.names[count.index]
#  map_public_ip_on_launch = var.public_ip_launch  # Allow EC2 instances in public subnets to have public IPs
#  tags = {
#    Name = "PublicSubnet-${count.index + 1}"
#    Type = "Public"
#  }
#}

#resource "aws_subnet" "private_subnets" {
#  count             = 2
#  vpc_id            = aws_vpc.eks_vpc.id
#  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 2)  # Start CIDR blocks after public subnets
#  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
#  tags = {
#    Name = "PrivateSubnet-${count.index + 1}"
#    Type = "Private"
#  }
#}

# Create an EIP for the NAT gateway
resource "aws_eip" "nat_eip" {
  
}

# Create NAT gateway
resource "aws_nat_gateway" "eks_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_one.id

  tags = {
    Name = "Natty GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.eks_igw]
}

# Create a route table for the private subnet
resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "My VPC Private Subnet Route Table"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "Public Subnet Route Table"
  }
}

# Create a route to the NAT gateway for the private subnet
resource "aws_route" "private_subnet_nat_gateway_route" {
  route_table_id         = aws_route_table.private_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gw.id
}

# Create a route to the internet gateway for the public subnet
resource "aws_route" "public_subnet_internet_gateway_route" {
  route_table_id         = aws_route_table.public_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_igw.id
}

# Associate the 1st public subnet with the public subnet route table
resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id      = aws_subnet.pub_one.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}


# Associate the 2nd public subnet with the public subnet route table
resource "aws_route_table_association" "public_subnet_route_table_association_2" {
  subnet_id      = aws_subnet.pub_two.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

# Associate the 1st private subnet with the private subnet route table
resource "aws_route_table_association" "private_subnet_route_table_association" {
  subnet_id      = aws_subnet.priv_one.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

# Associate the 2nd private subnet with the private subnet route table
resource "aws_route_table_association" "private_subnet_route_table_association_2" {
  subnet_id      = aws_subnet.priv_two.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}



