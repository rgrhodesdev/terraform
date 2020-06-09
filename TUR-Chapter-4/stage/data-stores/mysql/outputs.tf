output "address" {
    value = module.database_mysql.address
    description = "Database Endpoint"
}

output "port" {
    value = module.database_mysql.port
    description = "database listener port"
}