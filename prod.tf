provider "aws"{
  profile  =  "default"
  region   =  "us-west-2"
}

resource "aws_s3_bucket" "my-s3-prod-bucket"{
  bucket              =  "tf-my-bucket-21052020"
  acl                 =  "private"
}

resource "aws_default_vpc" "default" {}
