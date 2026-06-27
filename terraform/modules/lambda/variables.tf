variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "upload_bucket_name" {
  description = "Uploads bucket"
  type        = string
}

variable "processed_bucket_name" {
  description = "Processed bucket"
  type        = string
}