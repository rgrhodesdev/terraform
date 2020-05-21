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

data "aws_vpcs" "stage" {


  tags = {
    Name = "stage"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = element(tolist(data.aws_vpcs.stage.ids), 0)

  tags = {
    Name = "*Private*"
  }
}

output "private_subnets" {

value = data.aws_subnet_ids.private

}

data "aws_secretsmanager_secret_version" "db_creds" {
    secret_id = "mysql-master-password-stage"
}

resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "main_mysql"
  subnet_ids = data.aws_subnet_ids.private.ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "mysql_rds_sg" {

    vpc_id = element(tolist(data.aws_vpcs.stage.ids), 0)
    ingress {
        cidr_blocks = ["192.168.4.0/24", "192.168.5.0/24"]
        protocol = "tcp"
        from_port = 3306
        to_port = 3306
        

    }
    
    egress {

        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}




resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-up-and-running"
    engine = "mysql"
    allocated_storage = "10"
    instance_class = "db.t2.micro"
    name = "example_database"
    username = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["username"]
    password = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["password"]
    db_subnet_group_name = "main_mysql"
    vpc_security_group_ids = [aws_security_group.mysql_rds_sg.id]
    skip_final_snapshot = true


      
}