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

variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}