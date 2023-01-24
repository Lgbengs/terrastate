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

  availability_zone = "us-west-2a"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  availability_zone = "us-west-2a"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ec2_dev" {
  name        = "ec2_dev_sg"
  description = "Security group for EC2 instances in dev environment"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_prod" {
  name        = "ec2_prod_sg"
  description = "Security group for EC2 instances in prod environment"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

module "ec2_dev" {
  source = "terraform-aws-modules/ec2-instance/aws"

  subnet_id      = aws_subnet.public.id
  security_group = aws_security_group.ec2_dev.id
  key_name       = "class29key"
  state_bucket   = aws_s3_bucket.state_storage.bucket
  state_path     = "dev"
}

module "ec2_prod" {
  source = "terraform-aws-modules/ec2-instance/aws"

  subnet_id      = aws_subnet.private.id
  security_group = aws_security_group.ec2_prod.id
  key_name       = "class29key"
  state_bucket   = aws_s3_bucket.state_storage.bucket
  state_path     = "prod"
}
resource "aws_key_pair" "class29key" {
  key_name   = "class29key"
  public_key = file("class29key.pem")
}

terraform {
  backend "s3" {
    bucket = "aws_s3_bucket.state_storage.id"
    key    = "state_path/terraform.tfstate"
    region = "us-west-1"
  }
}
