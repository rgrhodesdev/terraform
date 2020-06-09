data "aws_subnet_ids" "example" {
  vpc_id = aws_vpc.dev_vpc.id

    tags = {
    Name = "*Private*"
  }
}

data "aws_subnet" "example" {
  for_each = data.aws_subnet_ids.example.ids
  id       = each.value
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.example : s.cidr_block]
}
