# Create a VPC
resource "aws_vpc" "main-vpc" {
  cidr_block = "10.117.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tage ={
    Name = "Main-VPC"
  }
}

# Create a public subnet
resource "aws_subnet" "vpc-public-subnet" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.117.10.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-V-subnet"
  }
}

# # Create a security group
# resource "aws_security_group" "virtual-security-group" {
#   name        = "VPC-main-security-group"
#   description = "The security group for the main VPC"
#   vpc_id      = aws_vpc.main-vpc.id


#   tags = {
#     Name = "vpc-subnet"
#   }
# }

# Create security rules for security group
# resource "aws_security_group_rule" "security-rule" {
#   for_each = var.rules
#   type              = each.value.type
#   from_port         = each.value.from_port
#   to_port           = each.value.to_port
#   protocol          = each.value.protocol
#   cidr_blocks       = [aws_vpc.main-vpc.cidr_block]
#   security_group_id = aws_security_group.virtual-security-group.id
# }

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow ssh"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main-vpc.cidr_block, "0.0.0.0/0"]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Create a internet gateway to access public internet
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "internet-gateway"
  }
}


# Create routing table from subnet to internet gateway
resource "aws_route_table" "vpc-routing-table" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "vpc-routing-table"
  }
}


# Create the route
resource "aws_route" "default" {
  route_table_id            = aws_route_table.vpc-routing-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.internet-gateway.id
  depends_on                = [aws_route_table.vpc-routing-table]
}

# Link the routes to the table
resource "aws_route_table_association" "routing_association" {
  subnet_id = aws_subnet.vpc-public-subnet.id
  route_table_id = aws_route_table.vpc-routing-table.id
}
