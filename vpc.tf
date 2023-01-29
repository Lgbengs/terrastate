resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  availability_zone = "us-east-1b"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet"
  }
}

module "ec2_dev" {

  source = "terraform-aws-modules/ec2-instance/aws"
  subnet_id  = aws_subnet.public.id
  key_name   = "class29key"

  tags = {
    "Name" = "EC2_Dev"
  }
 
}

module "ec2_prod" {

  source = "terraform-aws-modules/ec2-instance/aws"
  subnet_id = aws_subnet.private.id
  key_name  = "class29key"
 
  tags = {
    "Name" = "EC2_Prod"
  }
}

