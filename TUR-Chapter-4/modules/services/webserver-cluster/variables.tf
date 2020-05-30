variable "server_port" {

  description = "Web Server Port"
  type        = number
  default     = 8080

}

variable "alb_port" {

  description = "ALB Port"
  type        = number
  default     = 80

}

variable "cluster_name" {
  description = "The name to use for all cluster resources"
  type        = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the databases remote state"
  type        = string
}

variable "db_remote_state_key" {
  description = "The path for the databases remote state in S3"
  type        = string
}

variable "environment" {
  description = "Environment Type"
  type        = string
}