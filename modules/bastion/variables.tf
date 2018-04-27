variable "environment" {
  description = "The name of the environment"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "bastion_aws_ami" {
  description = "The AWS ami id to use"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type to use"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "The list of private subnets to place the instances in"
}

variable "key_name" {
  description = "SSH key name to be used"
}
