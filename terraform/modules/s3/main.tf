resource "aws_s3_bucket" "uploads" {
  bucket = "${var.project_name}-${var.environment}-${var.bucket_suffix}"

  tags = {
    Name = "${var.project_name}-${var.environment}-${var.bucket_suffix}"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}