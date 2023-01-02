# DynamoDB Table Setting
resource "aws_dynamodb_table" "terraform-state" {
  name           = var.dynamo_table
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
