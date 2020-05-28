provider "aws" {

  profile = "default"
  region = "us-west-2"

}

resource "aws_instance" "myec2_instance" {
    ami = "ami-0813245c0939ab3ca"
    instance_type = lookup(var.instance_type,terraform.workspace)
    // lookup(map,key)

  }



variable "instance_type"{
  type = "map"
  default={
    default = "t2.nano"
    dev     = "t2.micro"
    prd     = "t2.large"
  }
}
