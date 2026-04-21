output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

output "internet_gateway_id" {
  description = "Internet Gateway attached to the VPC; public subnet route tables use this for 0.0.0.0/0."
  value       = module.vpc.igw_id
}

output "public_subnet_ids" {
  description = "Two public subnets, one per AZ."
  value       = module.vpc.public_subnets
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.name
}

output "ecs_service_name" {
  value = module.ecs_service.name
}

output "ecs_task_security_group_id" {
  description = "Security group attached to Fargate tasks."
  value       = module.ecs_service.security_group_id
}

output "github_actions_role_arn" {
  description = "IAM role ARN for GitHub Actions OIDC federation."
  value       = aws_iam_role.github_actions.arn
}
