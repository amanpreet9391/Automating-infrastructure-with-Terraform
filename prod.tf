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
  count  =  2  

  ami                    =  "ami-0813245c0939ab3ca"
  instance_type          =  "t2.micro"
  vpc_security_group_ids =[
  aws_security_group.prod-security-group.id
  ]
tags = {
   "Terraform"  =  "true"
    }
}

resource "aws_eip_association" "prod_web"{
  instance_id        =  aws_instance.prod-web[0].id
  allocation_id      =  aws_eip.prod-eip.id
}

resource "aws_eip" "prod-eip" {
tags = {
  "Terraform"  =  "true"
  }
}

resource "aws_default_subnet" "prod_default_subnet_az1"{
  availability_zone  =  "us-west-2a"
  tags={
  "Terraform" = "true"
  }
}

resource "aws_default_subnet" "prod_default_subnet_az2"{
  availability_zone  =  "us-west-2b"
  tags={
  "Terraform" =  "true"
  }
}

resource "aws_elb" "prod_web"{
  name            =   "prod-web-ELB"
  instances       =   aws_instance.prod-web.*.id
  
  subnets         =   [aws_default_subnet.prod_default_subnet_az1.id , aws_default_subnet.prod_default_subnet_az2.id]
  security_groups =   [aws_security_group.prod-security-group.id ]

  listener{
  instance_port      =  80
  instance_protocol  =  "http"
  lb_port            =  80
  lb_protocol        =  "http"
  

}
}

resource "aws_launch_template" "prod-launch-template"{
  name_prefix   =  "prod-launch-template"
  image_id      = "ami-0813245c0939ab3ca"
  instance_type = "t2.micro"
}


resource "aws_autoscaling_group" "prod-asg"{
  
  availability_zones         =  ["us-west-2a","us-west-2b"]
  max_size                  = 2
  min_size                  = 1

  vpc_zone_identifier       =  [aws_default_subnet.prod_default_subnet_az1.id , aws_default_subnet.prod_default_subnet_az2.id]
  launch_template{
  id  =  aws_launch_template.prod-launch-template.id

}

}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.prod-asg.id
  elb                    = aws_elb.prod_web.id
}

