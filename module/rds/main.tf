# Database Subnet Group Resource
resource "aws_db_subnet_group" "db_subnet_group" {
  name = var.db_SG_name
  subnet_ids = var.subnet_ids
  tags = {
    "Name" = var.db_SG_name
  }
}

# Create database instance
resource "aws_db_instance" "app-database" {
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  allocated_storage = 10
  parameter_group_name = "default.mysql5.7"
  db_name = var.db_name
  username = var.username
  password = var.password
  identifier = var.identifier
  skip_final_snapshot = true
  publicly_accessible = true
  # multi_az = true
  vpc_security_group_ids = [ var.RDS_SG ]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
}