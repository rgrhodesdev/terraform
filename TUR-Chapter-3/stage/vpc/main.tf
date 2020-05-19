provider "aws" {
    region = "eu-west-1"

}

terraform {
    backend "s3" {
        bucket = "rgrhodesdev03-terraform-state-file"
        key = "stage/vpc/terraform.tfstate"
        region = "eu-west-1"

        dynamodb_table = "rgrhodesdev03-terraform-locks"
        encrypt = true


    }

}

resource "aws_vpc" "stage_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
      Name = "stage"
  }
}

resource "aws_internet_gateway" "stage_igw" {
    vpc_id = aws_vpc.stage_vpc.id
  
}


resource "aws_route_table" "stage_public_a_rt" {

    vpc_id = aws_vpc.stage_vpc.id   

    route {

        cidr_block = "0.0.0.0/0"
        gateway_id =  aws_internet_gateway.stage_igw.id

    }

    tags = {
        Name = "Dev Public RT A"
    }

}

resource "aws_route_table" "stage_public_b_rt" {

    vpc_id = aws_vpc.stage_vpc.id   

    route {

        cidr_block = "0.0.0.0/0"
        gateway_id =  aws_internet_gateway.stage_igw.id

    }

    tags = {
        Name = "Dev Public RT B"
    }

}

resource "aws_route_table" "stage_private_a_rt" {

    vpc_id = aws_vpc.stage_vpc.id
    # route {

    #     cidr_block = "0.0.0.0/0"
    #     instance_id = aws_instance.NATA.id
    # }

        tags = {
        Name = "Dev Private RT A"
    }
  
}

resource "aws_route_table" "stage_private_b_rt" {

    vpc_id = aws_vpc.stage_vpc.id
    # route {

    #     cidr_block = "0.0.0.0/0"
    #     instance_id = aws_instance.NATA.id
    # }

        tags = {
        Name = "Dev Private RT B"
    }
  
}


resource "aws_subnet" "publica" {
    vpc_id = aws_vpc.stage_vpc.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "eu-west-1a"

    tags = {
        Name = "Dev Public A"
    }

}

resource "aws_subnet" "publicb" {
    vpc_id = aws_vpc.stage_vpc.id
    cidr_block = "192.168.2.0/24"
    availability_zone = "eu-west-1b"

    tags = {
        Name = "Dev Public B"
    }

}

resource "aws_subnet" "privatea" {
    vpc_id = aws_vpc.stage_vpc.id
    cidr_block = "192.168.4.0/24"
    availability_zone = "eu-west-1a"

    tags = {

        Name = "Dev Private A"
    }

}

resource "aws_subnet" "privateb" {
    vpc_id = aws_vpc.stage_vpc.id
    cidr_block = "192.168.5.0/24"
    availability_zone = "eu-west-1b"

    tags = {

        Name = "Dev Private B"
    }

}

resource "aws_route_table_association" "stage_public_a_rt_assoc" {

    route_table_id = aws_route_table.stage_public_a_rt.id
    subnet_id = aws_subnet.publica.id

}

resource "aws_route_table_association" "stage_public_b_rt_assoc" {

    route_table_id = aws_route_table.stage_public_b_rt.id
    subnet_id = aws_subnet.publicb.id

}

resource "aws_route_table_association" "stage_private_art_assoc" {

    route_table_id = aws_route_table.stage_private_a_rt.id
    subnet_id = aws_subnet.privatea.id

}

resource "aws_route_table_association" "stage_private_brt_assoc" {

    route_table_id = aws_route_table.stage_private_b_rt.id
    subnet_id = aws_subnet.privateb.id

}


# resource "aws_instance" "NATA" {
    
    
#     ami = "ami-0236d0cbbbe64730c"
#     instance_type = "t2.micro"
#     subnet_id = aws_subnet.publica.id
#     associate_public_ip_address = true
#     vpc_security_group_ids = [aws_security_group.NATA_SG.id]
#     source_dest_check = false
#     key_name = "dev03_key"

#     tags = {

#         Name = "NAT Instance A"
#     }


# }

resource "aws_security_group" "NATA_SG" {

    name = "NATA_SG"
    description = "SG For NATA instance"
    vpc_id = aws_vpc.stage_vpc.id

    ingress {

        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = [aws_vpc.stage_vpc.cidr_block]

    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }


}