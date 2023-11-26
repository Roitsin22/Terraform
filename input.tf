terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

}


variable "ami" {
  type = map(any)
  default = {
    "us-east-1" = "ami-0230bd60aa48260c6"
    "us-east-2" = "ami-06d4b7182ac3480fa"
  }
}
variable "key" {
  type = map(any)
  default = {
    "us-east-1" = "My_key"
    "us-east-2" = "My_key2"
  }
}

# User input  

variable "selected_zone" {
  description = "Enter the desired AWS region ( us-east-1 or us-east-2) "
  type        = string
}

provider "aws" {
  region  = var.selected_zone
  profile = "default"
}

# Define variables
variable "Project" {
  #description = "Test_perpose"
  type    = string
  default = "xsay"
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

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.2.0.0/16"

  tags = {
    Name        = format("%s_%s_%s", var.Project, "vpc", var.owner)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}

# public subnet
resource "aws_subnet" "my_pub_sub1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.2.1.0/24"

  tags = {
    Name        = format("%s_%s_%s", var.Project, "Psub1", var.owner)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}
resource "aws_subnet" "my_pub_sub2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.2.2.0/24"

  tags = {
    Name        = format("%s_%s_%s", var.Project, "Psub2", var.owner)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}
resource "aws_subnet" "my_pub_sub3" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.2.3.0/24"

  tags = {
    Name        = format("%s_%s_%s", var.Project, "Psub3", var.owner)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}

#private subnet
resource "aws_subnet" "my_priv_sub1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.2.4.0/24"

  tags = {
    Name        = format("%s_%s_%s", var.Project, "Prsub1", var.owner)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}

resource "aws_subnet" "my_priv_sub2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.2.5.0/24"

  tags = {
    Name        = format("%s_%s_%s", var.Project, "Prsub2", var.owner)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}
resource "aws_subnet" "my_priv_sub3" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.2.6.0/24"

  tags = {
    Name        = format("%s_%s_%s", var.Project, "Prsub3", var.owner)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}

resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = format("%s_%s_%s", var.Project, "gate", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}

#public route table
resource "aws_route_table" "my_route_pub1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  tags = {
    Name        = format("%s_%s_%s", var.Project, "route_pub1", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner

  }

}
resource "aws_route_table" "my_route_pub2" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  tags = {
    Name        = format("%s_%s_%s", var.Project, "route_pub2", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner

  }

}
resource "aws_route_table" "my_route_pub3" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  tags = {
    Name        = format("%s_%s_%s", var.Project, "route_pub3", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner

  }

}

# private route table

resource "aws_route_table" "my_route_priv1" {
  vpc_id = aws_vpc.my_vpc.id

#   route {
#     cidr_block = "10.2.0.0/16"
#     gateway_id = "local"
    
#   }

  tags = {
    Name        = format("%s_%s_%s", var.Project, "route_priv1", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner

  }

}

resource "aws_route_table" "my_route_priv2" {
  vpc_id = aws_vpc.my_vpc.id

#   route {
#     cidr_block = "10.2.0.0/16"
#     gateway_id = "local"
    
#   }

  tags = {
    Name        = format("%s_%s_%s", var.Project, "route_priv2", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner

  }

}
resource "aws_route_table" "my_route_priv3" {
  vpc_id = aws_vpc.my_vpc.id

#   route {
#     cidr_block = "10.2.0.0/16"
#     gateway_id = "local"
    
#   }

  tags = {
    Name        = format("%s_%s_%s", var.Project, "route_priv3", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner

  }

}

# public route association
resource "aws_route_table_association" "accoPu1" {
  subnet_id      = aws_subnet.my_pub_sub1.id
  route_table_id = aws_route_table.my_route_pub1.id
}
resource "aws_route_table_association" "accoPu2" {
  subnet_id      = aws_subnet.my_pub_sub2.id
  route_table_id = aws_route_table.my_route_pub2.id
}
resource "aws_route_table_association" "accoPu3" {
  subnet_id      = aws_subnet.my_pub_sub3.id
  route_table_id = aws_route_table.my_route_pub3.id
}

# private route association
resource "aws_route_table_association" "accoPr1" {
  subnet_id      = aws_subnet.my_priv_sub1.id
  route_table_id = aws_route_table.my_route_priv1.id
}
resource "aws_route_table_association" "accoPr2" {
  subnet_id      = aws_subnet.my_priv_sub2.id
  route_table_id = aws_route_table.my_route_priv2.id
}
resource "aws_route_table_association" "accoPr3" {
  subnet_id      = aws_subnet.my_priv_sub3.id
  route_table_id = aws_route_table.my_route_priv3.id
}


# Security group
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
  ami                         = var.ami[var.selected_zone]
  instance_type               = "t2.micro"
  key_name                    = var.key[var.selected_zone]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.my_pub_sub1.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name        = format("%s_%s_%s", var.Project, "ec2", var.env)
    Environment = var.env
    Project     = var.Project
    Owner       = var.owner
  }
}