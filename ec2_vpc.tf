terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

}

provider "aws" {
  region  = "us-east-2"
  profile = "default"
}


# Define variables
variable "Project" {
  #description = "Test_perpose"
  type    = string
  default = "whatsapp"
}

variable "owner" {
  #description = "Test_perpose"
  type    = string
  default = "techo"
}
variable "env" {
  #description = "Test_perpose"
  type    = string
  default = "dev"
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
  
# create vpc

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.2.0.0/16"

  tags = {
    Name        = format("%s_%s_%s", var.Project, "vpc", var.owner)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}
 
# Subnet

resource "aws_subnet" "my_pub_sub" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.2.1.0/24"

  tags = {
    Name        = format("%s_%s_%s", var.Project, "Psub", var.owner)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}

#  Internet Gateway

resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = format("%s_%s_%s", var.Project, "gate", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}

  # Route Table

resource "aws_route_table" "my_route" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  tags = {
    Name        = format("%s_%s_%s", var.Project, "route", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner

  }

}

   # Associate Route table with Subnet

resource "aws_route_table_association" "acco" {
  subnet_id      = aws_subnet.my_pub_sub.id
  route_table_id = aws_route_table.my_route.id
}

   # Security group with port 22

resource "aws_security_group" "my_security_group" {
  
  description = "Security group for SSH access"
  vpc_id      = aws_vpc.my_vpc.id
   name        = format("%s_%s_%s", var.Project, "sg", var.env)
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere. Adjust as needed.
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = format("%s_%s_%s", var.Project, "sg", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}

  # EC2

resource "aws_instance" "my_ec2" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = "My_key"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.my_pub_sub.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name        = format("%s_%s_%s", var.Project, "ec2", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}

output "instance_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "image_id" {
  value = data.aws_ami.latest_amazon_linux.id
}