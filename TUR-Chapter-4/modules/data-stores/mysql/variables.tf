variable "db_name" {
    description = "The name to use for all cluster resources"
    type = string
}

variable "vpc_remote_state_bucket" {
    description = "The name of the S3 bucket for the vpc remote state"
    type = string
}

variable "vpc_remote_state_key" {
    description = "The path for the vpc remote state in S3"
    type = string

}