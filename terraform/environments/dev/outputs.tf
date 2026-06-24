output "vpc_id" {
  description = "VPC ID from network module"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs from network module"
  value       = module.network.public_subnet_ids
}