terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
# we used the us-esat-2 region
provider "aws" {
  region  = "us-east-2"
  profile = "default"
}

# here we create a security group with port 22
resource "aws_security_group" "my_security_group" {
  name        = "Test_Sgroup"
  description = "Example security group for EC2 instance"
  
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "S_group"
    Environment = "Dev"
  }
}

# create Ec2
resource "aws_instance" "my_ec2" {
  ami           = "ami-06d4b7182ac3480fa"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name        = "Ec2_instance"
    Environment = "Dev"
  }
  
}

