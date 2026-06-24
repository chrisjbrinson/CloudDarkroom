variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "container_image" {
  description = "Container image URI"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "subnet_ids" {
  description = "Subnet IDs for ECS service"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for ECS service"
  type        = string
}