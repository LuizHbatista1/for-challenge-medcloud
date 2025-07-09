resource "aws_db_subnet_group" "application_db_subnet_group" {
  name       = "${terraform.workspace}-db-subnet-group"
  subnet_ids = [
    aws_subnet.sn1.id,
    aws_subnet.sn2.id,
    aws_subnet.sn3.id
  ]
  tags = {
    Name = "${terraform.workspace} DB subnet group"
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "application-db-sg" {
  name        = "${terraform.workspace}-db-sg"
  description = "Permite acesso MySQL do ECS"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "MySQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.sg.id]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "application_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = lookup(var.environment_configs[terraform.workspace], "db_instance_class", "db.t3.micro")
  db_name        = "${terraform.workspace}_applicationDB"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true

  # Esses são os parâmetros importantes para VPC customizada:
  db_subnet_group_name   = aws_db_subnet_group.application_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.application-db-sg.id]

  # O RDS não terá IP público (por padrão)
  publicly_accessible    = false
}