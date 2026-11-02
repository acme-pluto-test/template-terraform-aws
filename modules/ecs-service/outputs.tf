output "cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.this.name
}

output "service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.this.name
}

output "launch_type" {
  description = "Launch type of the service."
  value       = aws_ecs_service.this.launch_type
}

output "assign_public_ip" {
  description = "Whether the tasks get a public IP address."
  value       = aws_ecs_service.this.network_configuration[0].assign_public_ip
}

output "task_role_arn" {
  description = "ARN of the role the application code runs as."
  value       = aws_iam_role.task.arn
}

output "execution_role_arn" {
  description = "ARN of the role that pulls the image and writes logs."
  value       = aws_iam_role.execution.arn
}

output "log_retention_days" {
  description = "Days the container logs are kept."
  value       = aws_cloudwatch_log_group.this.retention_in_days
}

output "container_definition" {
  description = "The container definition, as JSON."
  value       = aws_ecs_task_definition.this.container_definitions
}

output "circuit_breaker" {
  description = "The deployment circuit breaker: enable and rollback."
  value       = aws_ecs_service.this.deployment_circuit_breaker[0]
}

output "desired_count" {
  description = "How many tasks the service keeps running."
  value       = aws_ecs_service.this.desired_count
}
