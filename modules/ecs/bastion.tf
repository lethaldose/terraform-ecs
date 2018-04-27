module "bastion" {
  source = "../bastion"

  environment       = "${var.environment}"
  vpc_id            = "${module.network.vpc_id}"
  public_subnet_ids = "${module.network.public_subnet_ids}"
  instance_type     = "${var.instance_type}"
  bastion_aws_ami   = "${var.bastion_aws_ami}"
  key_name          = "${var.key_name}"
}

resource "aws_security_group_rule" "bastion_to_ecs" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "TCP"
  source_security_group_id = "${module.bastion.bastion_security_group_id}"
  security_group_id        = "${module.ecs_instances.ecs_instance_security_group_id}"
}

