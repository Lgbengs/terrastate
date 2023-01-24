variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "my_ami" {
  type    = string
  default = "ami-0ff8a91507f77f867"
}