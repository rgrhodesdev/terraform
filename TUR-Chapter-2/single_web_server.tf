/* variable "server_port" {

    description = "Web Server Port"
    type = number
    default = 8080

}


resource "aws_instance" "example" {

    ami = "ami-0dad359ff462124ca"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.publica.id
    vpc_security_group_ids = [aws_security_group.instance.id]
    associate_public_ip_address = true

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF

    tags = {
        Name = "terraform-example"
    }
}

resource "aws_security_group" "instance" {

    name = "terraform-example-instance"
    vpc_id = aws_vpc.dev_vpc.id

    ingress {

        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/32"]
    }
}

output "public_ip" {

    value = aws_instance.example.public_ip
    description = "Public IP of the Webserver"

} */