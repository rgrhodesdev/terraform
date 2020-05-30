provider "aws" {
    region = "eu-west-1"
}

terraform {
    backend "s3" {
        bucket = "rgrhodesdev03-terraform-state-file"
        key = "stage/services/webserver-cluster/terraform.tfstate"
        region = "eu-west-1"

        dynamodb_table = "rgrhodesdev03-terraform-locks"
        encrypt = true


    }

}

module "webserver-cluster" {

    source ="../../../modules/services/webserver-cluster"

    cluster_name = "webservers-stage"
    db_remote_state_bucket = "rgrhodesdev03-terraform-state-file"
    db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
    environment = "Stage"

}