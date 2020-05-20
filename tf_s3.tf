provider "aws"{
  profile  =  default
  region   =  "us-west-2"
}

resource "aws_s3-bucket" "tf_bucket"{
  bucket  =  "tf-s3-bucket-20052020"
  acl     =  "private"




}
