variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  default     = "default"
  description = "The name of the ECS cluster"
}

variable "ssm_parameter_prefix" {
  default     = ""
  description = "The prefix of the ssm parameters this role should be able to access"
}
