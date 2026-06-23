variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for public subnet A"
  type        = string
}



variable "availability_zone_b" {
  description = "Availability Zone for subnet B"
  type        = string
}