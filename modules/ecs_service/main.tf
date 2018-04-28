resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.repository_name}"
}

resource "aws_cloudwatch_log_group" "service_log_group" {
  name = "{var.environment}-{var.service}-log-group"

  tags {
    Environment = "${var.environment}"
    Application = "${var.service_name}"
  }
}

data "template_file" "service_task" {
  template = "${file("${path.module}/tasks/service-task-definition.json")}"

  vars {
    image           = "${aws_ecr_repository.ecr_repo.repository_url}/${var.service_name}:latest"
    log_group_name  = "${aws_cloudwatch_log_group.service_log_group.name}"
    service_name = "${var.service_name}"
    container_cpu = "${var.container_cpu}"
    container_memory = "${var.container_memory}"
    container_port = "${var.container_port}"
    log_group_region = "${var.region}"
  }
}

# The host port is dynamically chosen from the ephemeral port range of the
# container instance (such as 32768 to 61000 on the latest Amazon ECS-optimized AMI)

resource "aws_ecs_task_definition" "service_task_definition" {
  family                   = "${var.environment}-{var.service_name}-service"
  container_definitions    = "${data.template_file.service_task.rendered}"
  cpu                      = "${var.container_cpu}"
  memory                   = "${var.container_memory}"
  task_role_arn            = "${module.ecs_roles.ecs_task_role_arn}"

  tags {
    Environment = "${var.environment}"
    Application = "${var.service_name}"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name = "${var.environment}_${var.cluster_name}_${var.service_name}"
  cluster = "${var.cluster_name}"
  task_definition = "${aws_ecs_task_definition.service_task_definition.arn}"
  desired_count = "${var.desired_count}"
  iam_role = "${module.ecs_roles.ecs_service_role_arn}"

  load_balancer {
    target_group_arn = "${var.alb_target_group_arn}"
    container_name = "${var.service_name}"
    container_port = "${var.container_port}"
  }

  tags {
    Environment = "${var.environment}"
    Application = "${var.service_name}"
  }
}

module "ecs_roles" {
  source = "../ecs_roles"

  environment          = "${var.environment}"
  cluster              = "${var.cluster_name}"
  ssm_parameter_prefix = "${var.service_name}"
}

# --
# name = "${replace(var.service_name, "/(.{0,28})(.*)/", "$1")}-tg"