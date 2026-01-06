#
# Networking
#
resource "aws_vpc" "aws_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.project_name}-vpc-server"
  }
}

resource "aws_subnet" "aws_subnet" {
  vpc_id                  = aws_vpc.aws_vpc.id
  cidr_block              = var.vpc_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet-server"
  }
}

resource "aws_internet_gateway" "aws_internet_gateway" {
  vpc_id = aws_vpc.aws_vpc.id

  tags = {
    Name = "${var.project_name}-internet-gateway-server"
  }
}

resource "aws_route_table" "aws_route_table" {
  vpc_id = aws_vpc.aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.aws_internet_gateway.id
  }

  tags = {
    Name = "${var.project_name}-route-table-server"
  }
}

resource "aws_route_table_association" "rta_ec2" {
  subnet_id      = aws_subnet.aws_subnet.id
  route_table_id = aws_route_table.aws_route_table.id
}

# Create inboud rule for ssh 
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.aws_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-allow-ssh-server"
  }
}

# Create inboud rule for squid port, the default port is 3128
resource "aws_security_group" "squid_port" {
  name        = "squid_port"
  description = "Allow squid port traffic"
  vpc_id      = aws_vpc.aws_vpc.id
  ingress {
    from_port   = 3128
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.project_name}-squid-port-server"
  }
}
