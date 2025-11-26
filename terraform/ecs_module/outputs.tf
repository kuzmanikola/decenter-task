output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.cluster.name
}

output "cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.cluster.id
}

output "cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.cluster.arn
}

output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.service.name
}

output "service_id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.service.id
}

output "task_definition_arn" {
  description = "The ARN of the task definition"
  value       = aws_ecs_task_definition.definition.arn
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.group.name
}

output "execution_role_arn" {
  description = "The ARN of the task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "task_role_arn" {
  description = "The ARN of the task role (for application-level AWS access)"
  value       = aws_iam_role.ecs_task_role.arn
}