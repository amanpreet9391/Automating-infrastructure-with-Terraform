resource "aws_instance" "myec2instance" {
    ami  =  "ami-0813245c0939ab3ca"
    instance_type = var.instance_type
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
