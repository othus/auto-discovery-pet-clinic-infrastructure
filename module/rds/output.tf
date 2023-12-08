output "rds-endpoint" {
  value = aws_db_instance.app-database.endpoint
}