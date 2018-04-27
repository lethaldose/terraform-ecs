output "default_alb_target_group" {
  value = "${module.alb.default_alb_target_group}"
}

output "bastion_public_ip" {
  value = "${module.bastion.bastion_public_ip}"
}
