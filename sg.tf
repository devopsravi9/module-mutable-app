resource "aws_security_group" "main" {
  name        = "${local.TAG_PREFIX}-sg"
  description = "${local.TAG_PREFIX}-sg"
  vpc_id      = var.VPC_ID

  ingress {
    description      = "${var.COMPONENT}"
    from_port        = var.APP_PORT
    to_port          = var.APP_PORT
    protocol         = "tcp"
    cidr_blocks      = var.ALLOW_SG_CIDR
  }

  ingress {
    description      = "workstation"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = [var.WORKSTATION_IP]
  }

  ingress {
    description      = "prometheus"
    from_port        = 9100
    to_port          = 9100
    protocol         = "TCP"
    cidr_blocks      = [var.PROMETHEUS_IP]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.TAG_PREFIX}-sg"
  }
}