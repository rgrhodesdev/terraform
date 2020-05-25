provider "aws" {
    region = "eu-west-1"
}



resource "aws_s3_bucket" "terraform_state" {

    bucket = "rgrhodesdev03-terraform-state-file"

     
    lifecycle {
        prevent_destroy = true
    }


    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }

    }

}

resource "aws_dynamodb_table" "terraform_locks" {

    name = "rgrhodesdev03-terraform-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

terraform {
    backend "s3" {
        bucket = "rgrhodesdev03-terraform-state-file"
        key = "global/s3/terraform.tfstate"
        region = "eu-west-1"

        dynamodb_table = "rgrhodesdev03-terraform-locks"
        encrypt = true


    }

}



