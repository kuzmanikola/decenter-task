output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs_cluster.cluster_name
}

output "service_name" {
  description = "The name of the ECS service"
  value       = module.ecs_cluster.service_name
}

output "cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = module.ecs_cluster.cluster_arn
}

output "task_definition_arn" {
  description = "The ARN of the task definition"
  value       = module.ecs_cluster.task_definition_arn
}

output "cloudwatch_log_group" {
  description = "The CloudWatch log group name for viewing container logs"
  value       = module.ecs_cluster.cloudwatch_log_group_name
}