# Using a single workspace:
terraform {
  backend "remote" {
    hostname     = "replicated.yet.org"
    organization = "yet"

    workspaces {
      name = "terraform-aws-pov-sg"
    }
  }
}

provider aws {
  region  = "${var.aws_region}"
  version = "~> 1.50"
}

data "terraform_remote_state" "vpc" {
  backend = "atlas"

  config {
    name    = "yet/terraform-aws-vpc"
    address = "https://replicated.yet.org"
  }
}

resource "aws_security_group" "ssh_sg" {
  description = "Enable SSH access to our EC2 instances"
  name        = "ssh-sg"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
