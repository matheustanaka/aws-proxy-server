#
# Networking
#

module "networking" {
  source            = "./modules/networking/"
  project_name      = var.project_name
  vpc_cidr          = var.vpc_cidr
  availability_zone = var.availability_zone
}

#
# Server
#
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
  vpc_security_group_ids = [module.networking.aws_security_group_allow_ssh, module.networking.aws_security_group_squid_port]
  subnet_id              = module.networking.subnet_id
  key_name               = aws_key_pair.ssh_key.key_name
  user_data              = file("${path.module}/install.sh")
  tags = {
    Name = "${var.project_name}-server"
  }
}

resource "aws_key_pair" "ssh_key" {
  # key_name   = "ec2_ssh_key"
  key_name   = "ec2-new-key"
  public_key = var.public_key
}
