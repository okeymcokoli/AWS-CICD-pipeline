#Create s3 bucket
resource "aws_s3_bucket" "remote_bucket" {
    provider = aws.audit-account
    bucket = var.backend-s3-name
    count = var.enabled ? 1 : 0
   }

resource "aws_s3_bucket_versioning" "versioning_example" {
  provider = aws.audit-account
  bucket = var.backend-s3-name
  count = var.enabled ? 1 : 0
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "example" {
  provider = aws.audit-account
  bucket = aws_s3_bucket.remote_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  count = var.enabled ? 1 : 0
}