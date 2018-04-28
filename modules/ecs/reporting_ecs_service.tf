module "reporting_ecs_service" {
  source = "../ecs_service"

  environment             = "${var.environment}"
  region                  = "${var.region}"
  cluster_name            = "${var.cluster}"
  vpc_id                  = "${module.network.vpc_id}"

  repository_name         = "reporting-service-repo"
  service_name            = "reporting-service"
  container_cpu           = 512
  container_memory        = 512
  container_port          = 3002
  desired_count           = 1
  alb_target_group_arn    = "${module.alb.default_alb_target_group}"
}
