output "endpoint" {
  description = "RDS endpoint"

  value = aws_db_instance.this.endpoint
}

output "address" {
  description = "RDS hostname"

  value = aws_db_instance.this.address
}

output "port" {
  description = "PostgreSQL port"

  value = aws_db_instance.this.port
}

output "database_name" {
  description = "Database name"

  value = aws_db_instance.this.db_name
}

output "security_group_id" {
  description = "RDS security group"

  value = aws_security_group.rds.id
}