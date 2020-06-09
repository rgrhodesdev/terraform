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

module "environment_vpc" {
    source ="../../modules/vpc"

    vpc_name = "stage"
    vpc_cidr = "192.168.0.0/16"
    public_subnet_a = "192.168.1.0/24"
    public_subnet_b = "192.168.2.0/24"
    private_subnet_a = "192.168.4.0/24"
    private_subnet_b = "192.168.5.0/24"


}