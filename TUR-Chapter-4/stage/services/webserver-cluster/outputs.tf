output "alb_dns_name" {

  value       = module.webserver-cluster.alb_dns_name
  description = "ALB DNS Name"

}