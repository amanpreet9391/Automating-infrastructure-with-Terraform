provider "aws" {
  profile  =  "default"
  region = "us-west-2"
}

resource "aws_security_group" "dynamic-sg" {
  name = "dynamic_sg"
  dynamic "ingress"{


      for_each = var.ingress_ports
      content{
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
}
