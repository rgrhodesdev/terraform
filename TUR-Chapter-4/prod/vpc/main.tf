provider "aws" {
    region = "eu-west-1"

}

terraform {
    backend "s3" {
        bucket = "rgrhodesdev03-terraform-state-file"
        key = "prod/vpc/terraform.tfstate"
        region = "eu-west-1"

        dynamodb_table = "rgrhodesdev03-terraform-locks"
        encrypt = true


    }

}

module "environment_vpc" {
    source ="../../modules/vpc"

    vpc_name = "Prod"
    vpc_cidr = "10.0.0.0/16"
    public_subnet_a = "10.0.1.0/24"
    public_subnet_b = "10.0.2.0/24"
    private_subnet_a = "10.0.4.0/24"
    private_subnet_b = "10.0.5.0/24"


}