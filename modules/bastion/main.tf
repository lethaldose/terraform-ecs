resource "aws_instance" "bastion" {
  ami                         = "${var.bastion_aws_ami}"
  key_name                    = "${var.key_name}"
  instance_type               = "${var.instance_type}"

  subnet_id                   = "${element(var.public_subnet_ids, 0)}"
  # security_groups             = ["${aws_security_group.bastion_sg.name}"]
  # vpc_security_group_ids      = ["${split(",",var.security_groups)}"]
  vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.bastion_profile.name}"

  source_dest_check           = false
  associate_public_ip_address = true
  monitoring                  = true

  tags {
    Name        = "${var.environment}-bastion"
    Environment = "${var.environment}"
  }
}


resource "aws_security_group" "bastion_sg" {
  name        = "${var.environment}-bastion-sg"
  description = "Allow access from allowed_network to SSH/Consul, and NAT internal traffic"
  vpc_id      = "${var.vpc_id}"

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

  # Can access anything on the internet via http
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}-bastion"
    Environment = "${var.environment}"
  }
}

# IAM

data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.environment}-bastion-profile"
  role = "${aws_iam_role.bastion_iam_role.name}"
}

resource "aws_iam_role" "bastion_iam_role" {
  name = "${var.environment}-bastion-role"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.assume-role-policy.json}"
}

# resource "aws_instance" "bastion" {
  # ami                    = "${module.ami.ami_id}"
  # source_dest_check      = false
  # instance_type          = "${var.instance_type}"
  # subnet_id              = "${var.subnet_id}"
  # key_name               = "${var.key_name}"
  # vpc_security_group_ids = ["${split(",",var.security_groups)}"]
  # monitoring             = true
  # user_data              = "${file(format("%s/user_data.sh", path.module))}"

  # tags {
    # Name        = "bastion"
    # Environment = "${var.environment}"
  # }
# }

# resource "aws_instance" "bastion" {
  # ami = "${lookup(var.amazon_amis, var.region)}"
  # instance_type = "t2.micro"
  # key_name = "${var.ssh_key_name}"
  # vpc_security_group_ids = [
  #   "${aws_security_group.bastion.id}"
  # ]
  # subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
  # associate_public_ip_address = true
  # source_dest_check           = false
  # iam_instance_profile        = "${aws_iam_instance_profile.bastion_profile.name}"

  # tags = {
    # Name = "${var.env_name}-bastion"
    # ManagedBy = "Terraform"
  # }
# }