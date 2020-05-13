variable "server_port" {

    description = "Web Server Port"
    type = number
    default = 8080

}

variable "alb_port" {

    description = "ALB Port"
    type = number
    default = 80

}

data "aws_subnet_ids" "private" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "*Private*"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "*Public*"
  }
}

resource "aws_lb" "example" {

    name = "terraform-asg-example"
    load_balancer_type = "application"
    subnets = data.aws_subnet_ids.public.ids
    security_groups = [aws_security_group.alb.id]

}

resource "aws_lb_listener" "http" {

    load_balancer_arn = aws_lb.example.arn
    port = 80
    protocol = "HTTP"

    default_action {

        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: Page Not Found"
            status_code = 404

        }

    }

}

resource "aws_lb_listener_rule" "asg" {

    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {

        field = "path-pattern"
        values = ["*"]

    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.asg.arn

    }

}

resource "aws_lb_target_group" "asg" {

    name = "terraform-asg-example"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = aws_vpc.dev_vpc.id

    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }

}




resource "aws_launch_configuration" "example" {

    image_id = "ami-0dad359ff462124ca"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instance.id]
    associate_public_ip_address = false

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF

    lifecycle {

        create_before_destroy = true

    }
}

resource "aws_autoscaling_group" "example" {

    launch_configuration = aws_launch_configuration.example.name
    vpc_zone_identifier = data.aws_subnet_ids.private.ids
    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"
  

    min_size = 2
    max_size = 3

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }

}

resource "aws_security_group" "instance" {

    name = "terraform-example-instance"
    vpc_id = aws_vpc.dev_vpc.id

    ingress {

        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]
    }
}

resource "aws_security_group" "alb" {

    name = "terraform-example-alb"
    vpc_id = aws_vpc.dev_vpc.id

    ingress {

        from_port = var.alb_port
        to_port = var.alb_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {

        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }


}

output "alb_dns_name" {

    value = aws_lb.example.dns_name
    description = "ALB DNS Name"

}
