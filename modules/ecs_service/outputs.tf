output "service_name" {
  value = "${aws_ecs_service.ecs_service.name}"
}

output "ecr_repo" {
  value = "${aws_ecr_repository.ecr_repo.name}"
}
