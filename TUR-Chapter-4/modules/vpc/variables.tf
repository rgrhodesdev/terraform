variable "vpc_name" {
    description = "VPC Name"
    type = string
}

variable "vpc_cidr" {

    description = "VPC CIDR"
    type = string

}

variable "public_subnet_a" {
    description = "Public Subnet A CIDR"
    type = string
}

variable "public_subnet_b" {
    description = "Public Subnet B CIDR"
    type = string
}

variable "private_subnet_a" {
    description = "Public Subnet A CIDR"
    type = string
}

variable "private_subnet_b" {
    description = "Public Subnet B CIDR"
    type = string
}
