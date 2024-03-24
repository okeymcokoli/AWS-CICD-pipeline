#dynamodb
resource "aws_dynamodb_table" "terraform-lock" {
    name           = var.backend-dynamodb-name
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    deletion_protection_enabled = true
    attribute {
        name = "LockID"
        type = "S"
    }
count = var.enabled ? 1 : 0
}