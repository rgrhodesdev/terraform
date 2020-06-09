

data "terraform_remote_state" "vpc" {
  backend = "s3" 

  config = {
    bucket = var.vpc_remote_state_bucket
    key = var.vpc_remote_state_key
    region = "eu-west-1"
  }

}

data "aws_vpcs" "environment" {


  tags = {
    Name = var.environment
  }
}


data "aws_subnet_ids" "private" {
  vpc_id = element(tolist(data.aws_vpcs.environment.ids), 0)
  tags = {
    Name = "*Private*"
  }
}

output "private_subnets" {

value = data.aws_subnet_ids.private

}

data "aws_secretsmanager_secret_version" "db_creds" {
    secret_id = var.db_creds_secret
}

resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "${var.db_name}-mysql"
  subnet_ids = data.aws_subnet_ids.private.ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "mysql_rds_sg" {
    name = "${var.environment}-RDS-SG"
    vpc_id = element(tolist(data.aws_vpcs.environment.ids), 0)

}

resource "aws_security_group_rule" "allow_mysql_inbound" {

  type = "ingress"
  security_group_id = aws_security_group.mysql_rds_sg.id

  cidr_blocks = ["192.168.4.0/24", "192.168.5.0/24"]
  protocol = "tcp"
  from_port = 3306
  to_port = 3306

}

resource "aws_security_group_rule" "allow_mysql_outbound" {

  type = "egress"
  security_group_id = aws_security_group.mysql_rds_sg.id

  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]



}
    

resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-up-and-running"
    engine = "mysql"
    allocated_storage = "10"
    instance_class = "db.t2.micro"
    name = "${var.db_name}database"
    username = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["username"]
    password = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["password"]
    db_subnet_group_name = "${var.db_name}-mysql"
    vpc_security_group_ids = [aws_security_group.mysql_rds_sg.id]
    skip_final_snapshot = true


      
}