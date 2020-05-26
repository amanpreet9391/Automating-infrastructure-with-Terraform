provider "aws" {
  profile     =  "default"
  region  =  "us-west-2"
}

variable "isTest" {}

//Resources associated with Dev block
resource "aws_instance" "dev" {
  ami             =  "ami-0813245c0939ab3ca"
  instance_type   = "t2.micro"
  count = var.isTest == true ? 1:0
}




//Resources associated with Production block
resource "aws_instance" "prod" {
  ami             =  "ami-0813245c0939ab3ca"
  instance_type   = "t2.large"
  count = var.isTest == false ? 1:0
}
