provider "aws" {
    region = "eu-west-1"
}

terraform {
    backend "s3" {
        bucket = "rgrhodesdev03-terraform-state-file"
        key = "stage/data-stores/mysql/terraform.tfstate"
        region = "eu-west-1"

        dynamodb_table = "rgrhodesdev03-terraform-locks"
        encrypt = true


    }
}


module "database_mysql" {
    source ="../../../modules/data-stores/mysql"

    db_name = "database-stage"
    vpc_remote_state_bucket = "rgrhodesdev03-terraform-state-file"
    vpc_remote_state_key = "stage/vpc/terraform.tfstate"

}
