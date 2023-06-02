variable "dynamodb_checkin_table_name" {
  default = "Checkin"
}

resource "aws_dynamodb_table" "checkin-table" {
  name = var.dynamodb_checkin_table_name
  read_capacity = 20
  write_capacity = 20
  hash_key = "id"
  
  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = var.dynamodb_checkin_table_name
    Environment = "free-tier"
  }
}