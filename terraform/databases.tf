## https://developer.hashicorp.com/terraform/tutorials/aws/aws-rds?in=terraform%2Faws&utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS
#
#
#resource "aws_db_subnet_group" "cse41379" {
#  name       = "cse41379"
#  subnet_ids = aws_subnet.private_subnets
#
#  tags = {
#    Name = "My DB subnet group"
#  }
#}
#resource "aws_db_instance" "default" {
#  allocated_storage    = 10
#  db_name              = "mydb"
#  engine               = "mysql"
#  engine_version       = "8.0"
#  instance_class       = "db.t3.micro"
#  username             = "foo"
#  password             = "foobarbaz"
#  parameter_group_name = "default.mysql8.0"
#  skip_final_snapshot  = true
#  db_subnet_group_name = aws_subnet.private_subnets[0].id
#
#  db_subnet_group_name   = aws_db_subnet_group.education.name
#  vpc_security_group_ids = [aws_security_group.rds.id]
#}
