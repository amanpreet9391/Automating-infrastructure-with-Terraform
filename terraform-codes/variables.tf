variable "vpn_ip"{
  default  =  "54.190.96.18/32"
}
//variable "instance_type" {}

variable "az"{
  type  =  list(string)
}
variable "types"{
  type  = map
  default = {
    us-west-1  =  "t2.nano"
    us-west-2  =  "t2.micro"
    us-east-1  =  "t2.large"
  }
}
variable "aws_region"{
  type = string
}
