variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "bucket_suffix" {
  type = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function to invoke"
  type        = string
  default = null
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default = null
}