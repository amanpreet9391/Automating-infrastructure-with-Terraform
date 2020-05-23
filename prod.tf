variable "whitelist"{
  type  =  list(string)
 }            

variable "web_image_id"{
  type  =  string
}          

variable "web_instance_type"{
  type  =  string
}     

variable "web_max_size"{
  type  =  number
}         

variable "web_min_size"{
  type  =  number
}          

variable "web_desired_capacity"{
  type  =  number
}  











provider "aws"{
  profile  =  "default"
  region   =  "us-west-2"
}

resource "aws_s3_bucket" "my-s3-prod-bucket"{
  bucket              =  "tf-my-bucket-21052020"
  acl                 =  "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web"{

  
  ingress{
    from_port     =  40
    to_port       =  40
    protocol      =  "tcp"
    cidr_blocks   =  var.whitelist 
     
  }

  ingress{
    from_port    =  443
    to_port      =  443
    protocol     =  "tcp"
    cidr_blocks  =  var.whitelist 
  }

  egress{
    from_port    =  0
    to_port      =  0
    protocol     =  "-1"
    cidr_blocks  =  var.whitelist 
  }  
}

resource "aws_instance" "prod_web"{
  count  =  2  

  ami                    =  "ami-0813245c0939ab3ca"
  instance_type          =  "t2.micro"
  vpc_security_group_ids =[
  aws_security_group.prod_web.id
  ]
tags = {
   "Terraform"  =  "true"
    }
}

resource "aws_eip_association" "prod_web"{
  instance_id        =  aws_instance.prod_web[0].id
  allocation_id      =  aws_eip.prod-eip.id
}

resource "aws_eip" "prod-eip" {
tags = {
  "Terraform"  =  "true"
  }
}

resource "aws_default_subnet" "prod_web_default_subnet_az1"{
  availability_zone  =  "us-west-2a"
  tags={
  "Terraform" = "true"
  }
}

resource "aws_default_subnet" "prod_web_default_subnet_az2"{
  availability_zone  =  "us-west-2b"
  tags={
  "Terraform" =  "true"
  }
}




             
          
     
 module "web_app"{
     source = "./modules/web_app"
 
  whitelist            =  var.whitelist
  web_image_id         =  var.web_image_id
  web_instance_type    =  var.web_instance_type
  web_max_size         =  var.web_max_size
  web_min_size         =  var.web_min_size
  web_desired_capacity =  var.web_desired_capacity
  security_groups      =  [aws_security_group.prod_web.id]
  subnets              =  [aws_default_subnet.prod_web_default_subnet_az1.id , aws_default_subnet.prod_web_default_subnet_az2.id]
  web_app              =   "prod"  

 }













             
          
     
  










