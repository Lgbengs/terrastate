variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "my_ami" {
  type    = string
  default = "ami-0ff8a91507f77f867"
}

variable "state_paths" {
  type    = list(string)
  default = ["state_path_dev", "state_path_prod"]
}
