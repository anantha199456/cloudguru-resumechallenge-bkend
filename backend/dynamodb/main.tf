resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Website"

  attribute {
    name = "Website"
    type = "S"
  }

}