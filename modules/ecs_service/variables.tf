variable "environment" {
  description = "The name of the environment"
}

variable "region" {
  description = "AWS region to deploy to (e.g. ap-southeast-2)"
}

variable "cluster_name" {
  description = "Name of ECS cluster"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "repository_name" {
  description = "The name of ECR repository"
}

variable "service_name" {
  description = "The name of the service"
}

variable "container_cpu" {
  description = "The number of cpu units to reserve for the container. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html"
}

variable "container_memory" {
  description = "The number of MiB of memory to reserve for the container. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html"
}

variable "container_port" {
  description = "Port that service will listen on"
}

variable "desired_count" {
  description = "Initial number of containers to run"
}

#-- will come from tf remote config

variable "ecs_service_role_arn" {
  description = "ECS ALB Service role"
}

variable "alb_target_group_arn" {
  description = "ALB Target group arn for routing"
}
