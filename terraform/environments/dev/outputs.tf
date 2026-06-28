output "vpc_id" {
  description = "VPC ID from network module"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs from network module"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs from network module"
  value       = module.network.private_subnet_ids
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "github_actions_role_arn" {
  description = "GitHub Actions role ARN"
  value       = module.github_oidc.role_arn
}

output "rds_endpoint" {
  description = "Endpoint for PostgreSQL RDS"
  value = module.rds.endpoint
}

output "ecs_security_group_id" {
  description = "ECS Security Group ID"
  value = module.network.ecs_security_group_id
}