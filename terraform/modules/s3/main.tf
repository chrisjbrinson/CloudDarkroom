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

resource "aws_lambda_permission" "s3" {
  count = var.lambda_function_name != null ? 1 : 0

  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.uploads.arn
}

resource "aws_s3_bucket_notification" "lambda" {
  count = var.lambda_function_arn != null ? 1 : 0

  bucket = aws_s3_bucket.uploads.id

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events = [
      "s3:ObjectCreated:*"
    ]
  }

  depends_on = [
    aws_lambda_permission.s3
  ]
}