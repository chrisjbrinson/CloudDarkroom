data "aws_iam_policy_document" "s3" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.upload_bucket_name}/*"
    ]
  }

  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${var.processed_bucket_name}/*"
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-${var.environment}-lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3" {
  name = "${var.project_name}-${var.environment}-lambda-s3"

  role = aws_iam_role.lambda.id

  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  role = aws_iam_role.lambda.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_function" "this" {
  function_name = "${var.project_name}-${var.environment}"

  role    = aws_iam_role.lambda.arn
  handler = "handler.lambda_handler"
  runtime = "python3.13"
  environment {
     variables = {
       UPLOAD_BUCKET_NAME    = var.upload_bucket_name
       PROCESSED_BUCKET_NAME = var.processed_bucket_name
    }
  }

  filename         = "${path.root}/../../../lambda/package.zip"
  source_code_hash = filebase64sha256("${path.root}/../../../lambda/package.zip")
}