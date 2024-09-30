data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "aws_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.squid_port.id]
  subnet_id              = aws_subnet.aws_subnet.id
  key_name               = aws_key_pair.ssh_key.key_name
  user_data              = file("${path.module}/install.sh")
  tags = {
    Name = "server"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ec2_ssh_key"
  public_key = var.public_key
}

resource "aws_vpc" "aws_vpc" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-server"
  }
}

resource "aws_subnet" "aws_subnet" {
  vpc_id                  = aws_vpc.aws_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-server"
  }
}


resource "aws_internet_gateway" "aws_internet_gateway" {
  vpc_id = aws_vpc.aws_vpc.id

  tags = {
    Name = "internet-gateway-server"
  }
}

resource "aws_route_table" "aws_route_table" {
  vpc_id = aws_vpc.aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.aws_internet_gateway.id
  }

  tags = {
    Name = "route-table-server"
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
    Name = "allow-ssh-server"
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
    Name = "squid-port-server"
  }
}
