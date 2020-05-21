provider "aws"{
  profile  =  "default"
  region   =  "us-west-2"
}

resource "aws_s3_bucket" "my-s3-prod-bucket"{
  bucket              =  "tf-my-bucket-21052020"
  acl                 =  "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod-security-group"{

  
  ingress{
    from_port     =  40
    to_port       =  40
    protocol      =  "tcp"
    cidr_blocks   =  ["0.0.0.0/0"]
     
  }

  ingress{
    from_port    =  443
    to_port      =  443
    protocol     =  "tcp"
    cidr_blocks  =  ["0.0.0.0/0"]
  }

  egress{
    from_port    =  0
    to_port      =  0
    protocol     =  "-1"
    cidr_blocks  =  ["0.0.0.0/0"]
  }  
}

resource "aws_instance" "prod-web"{
  ami                    =  "ami-0813245c0939ab3ca"
  instance_type          =  "t2.micro"
  vpc_security_group_ids =[
  aws_security_group.prod-security-group.id
  ]
tags = {
   "Terraform"  =  "true"
    }
}

resource "aws_eip" "prod-eip" {
  instance =  aws_instance.prod-web.id
tags = {
  "Terraform"  =  "true"
  }
}
