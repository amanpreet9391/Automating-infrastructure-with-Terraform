provider "aws" {

  profile = "default"
  region = "us-west-2"

}

resource "aws_instance" "myec2_instance" {
    ami = "ami-0813245c0939ab3ca"
    instance_type = "t2.micro"
    key_name = "terraform"
    provisioner "remote-exec" {
      inline=[
      "sudo amazon-linux extras install -y nginx1.12",
      "sudo systemctl start nginx"
    ]


    connection{
      type = "ssh"
      user = "ec2-user"
      private_key = file("./terraform.pem")
      host = self.public_ip
    }
  }
}
