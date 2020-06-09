provider "aws" {
    region = "eu-west-1"

}

resource "aws_instance" "cfinstance" {
    ami = "ami-0ea3405d2d2522162"
    instance_type = "t2.micro"

}