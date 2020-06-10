provider "aws" {
    region = "eu-west-1"
}

resource "aws_instance" "myinstance" {

    ami = "ami-0ea3405d2d2522162"
    instance_type = "t2.micro"
    subnet_id = "subnet-0c573b58108ab609e"
    //iam_instance_profile = "generic-ec2-instance-InstanceProfile-1TR85H5DYX87C"

}