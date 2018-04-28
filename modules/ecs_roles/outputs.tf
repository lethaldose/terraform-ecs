# ECS task role arn for accessing SSM parameters access
output "ecs_task_role_arn" {
  value = "${aws_iam_role.ecs_default_task.arn}"
}

# ECS service role for ECS to manage the load balancer associated with the service
output "ecs_service_role_arn" {
  value = "${aws_iam_role.ecs-service-role.arn}"
}
