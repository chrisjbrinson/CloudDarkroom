resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:chrisjbrinson/CloudDarkroom:ref:refs/heads/main"
      ]
    }
  }
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }
  statement {
    actions = [
      "ecs:RunTask",
      "ecs:DescribeTasks"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:GetFunction",
      "lambda:UpdateFunctionCode"
    ]

    resources = [
      "arn:aws:lambda:us-east-1:875852488827:function:${var.project_name}-${var.environment}"
    ]
  }
  statement {
    actions = [
      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::875852488827:role/clouddarkroom-dev-ecs-task",
      "arn:aws:iam::875852488827:role/clouddarkroom-dev-ecs-task-execution"
    ]
  }
}

resource "aws_iam_policy" "github_actions" {
  name        = "${var.project_name}-${var.environment}-ecr-push"
  description = "Allow GitHub Actions to push images to ECR"

  policy = data.aws_iam_policy_document.github_actions.json
}

resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-${var.environment}-github-actions"

  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = {
    Name        = "${var.project_name}-${var.environment}-github-actions"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}