data "aws_secretsmanager_secret" "datadog_api_key" {
  name = "clouddarkroom/datadog/api-key"
}

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

resource "aws_iam_role_policy_attachment" "vpc_access" {
  role = aws_iam_role.lambda.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "datadog_secret" {
  name = "${var.project_name}-${var.environment}-lambda-datadog-secret"

  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = data.aws_secretsmanager_secret.datadog_api_key.arn
      }
    ]
  })
}

resource "aws_lambda_function" "this" {
  function_name = "${var.project_name}-${var.environment}"

  role    = aws_iam_role.lambda.arn
  #handler = "handler.lambda_handler"
  handler = "datadog_lambda.handler.handler"
  runtime = "python3.13"
  timeout = 30

  layers = [
    "arn:aws:lambda:us-east-1:464622532012:layer:Datadog-Python313:125",
    "arn:aws:lambda:us-east-1:464622532012:layer:Datadog-Extension:96"
  ]

  environment {
     variables = {
       UPLOAD_BUCKET_NAME    = var.upload_bucket_name
       PROCESSED_BUCKET_NAME = var.processed_bucket_name
       DB_HOST = var.db_host
       DB_NAME = var.db_name
       DB_USER = var.db_user
       DB_PASSWORD = var.db_password
       DD_SITE = "us5.datadoghq.com"
       DD_SERVICE = "clouddarkroom-lambda"
       DD_ENV = var.environment
       DD_API_KEY_SECRET_ARN    = data.aws_secretsmanager_secret.datadog_api_key.arn
       DD_LAMBDA_HANDLER = "handler.lambda_handler"

    }
  }
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [
        var.security_group_id
    ]
  }

  filename         = "${path.root}/../../../lambda/package.zip"
  source_code_hash = filebase64sha256("${path.root}/../../../lambda/package.zip")
}