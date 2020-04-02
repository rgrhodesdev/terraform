resource "aws_vpc" "dev_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
      Name = "Dev"
  }
}

resource "aws_internet_gateway" "dev_igw" {
    vpc_id = aws_vpc.dev_vpc.id
  
}


resource "aws_route_table" "dev_public_a_rt" {

    vpc_id = aws_vpc.dev_vpc.id   

    route {

        cidr_block = "0.0.0.0/0"
        gateway_id =  aws_internet_gateway.dev_igw.id

    }

    tags = {
        Name = "Dev Public RT A"
    }

}

resource "aws_subnet" "publica" {
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = "192.168.1.0/24"

    tags = {
        Name = "Dev Public A"
    }

}

resource "aws_route_table_association" "dev_public_a_rt_assoc" {

    route_table_id = aws_route_table.dev_public_a_rt.id
    subnet_id = aws_subnet.publica.id

}