provider "aws" {
  profile  =  "default"
  aws_region  =  "us-west-2"
}

resource "aws_instance" "myec2instance" {
    ami  =  "ami-0813245c0939ab3ca"
    instance_type = "t2.micro"
}

resource "aws_eip" "myelasticip"{
  vpc  =  true
}

resource "aws_eip_association" "eip_association" {

  instance_id      =  aws_instance.myec2instance.id
  allocation_id    =  aws_eip.myelasticip.id

}

resource "aws_security_group" "my_security_group" {
    name = "my-security-group"
    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["${aws_eip.myelasticip.public_ip}/32"]

    }
}
