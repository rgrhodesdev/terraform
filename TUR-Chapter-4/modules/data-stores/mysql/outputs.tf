output "address" {
    value = aws_db_instance.example.address
    description = "Database Endpoint"
}

output "port" {
    value = aws_db_instance.example.port
    description = "database listener port"
}