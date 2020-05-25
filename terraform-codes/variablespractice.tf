resource "aws_instance" "myec2instance" {
  //  instance_name  = "ec2instance.${count.index}"
//  instance_name    =  "ec2-instance"
    ami            =  "ami-0813245c0939ab3ca"
    instance_type  = var.types[var.aws_region]
  //  count          =  3


}

resource "aws_security_group" "security_group_for_varibale_testing"{
  name = "security-group-variable-testing"
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.vpn_ip]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.vpn_ip]
  }
  ingress {
    from_port = 53
    to_port = 53
    protocol = "tcp"
    cidr_blocks = [var.vpn_ip]
  }

}

resource "aws_elb" "my_elb" {
  name               = "my-terraform-elb"
  availability_zones = var.az



  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

}

resource "aws_iam_user" "my_iam_role" {
    name  = "loadbalancer.${count.index}"
    count = 2
    path = "/system"
}

  //instances                   = aws_instance.myec2instance.id
