resource "aws_spot_instance_request" "main" {
  count                       = var.INSTANCE_COUNT
  ami                         = data.aws_ami.main.id
  spot_price                  = data.aws_ec2_spot_price.main.spot_price
  instance_type               = var.APP_INSTANCE_CLASS
  wait_for_fulfillment        = true
  vpc_security_group_ids      = [aws_security_group.main.id]
  subnet_id                   = var.PRIVATE_SUBNET_ID[0]
  iam_instance_profile        = aws_iam_instance_profile.secrets.name

  tags = {
    Name = local.TAG_PREFIX
  }
}

resource "aws_ec2_tag" "main" {
  count       = var.INSTANCE_COUNT
  resource_id = aws_spot_instance_request.main.*.spot_instance_id[count.index]
  key         = "Name"
  value       = local.TAG_PREFIX
}

resource "null_resource" "ansible" {
  triggers = {
    abc = timestamp()
  }
  count = var.INSTANCE_COUNT
  provisioner "remote-exec" {
    connection {
      user     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_USER"]
      password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_PASS"]
      host     = aws_spot_instance_request.main.*.private_ip[count.index]
    }
    inline = [
      "git clone https://github.com/devopsravi9/roboshop-ansible.git",
      "cd /home/centos/roboshop-ansible/ansible",
      "git pull",
      "ansible-playbook robo.yml -e HOST=localhost -e ROLE=${var.COMPONENT} -e ENV=${var.ENV} -e DOCDB_ENDPOINT=${var.DOCDB_ENDPOINT} -e REDDIS_ENDPOINT=${var.REDDIS_ENDPOINT}  -e RDS_ENDPOINT=${var.RDS_ENDPOINT}",
    ]

  }
}