
locals {

  user_data = <<-EOT
  #!/bin/bash
  aws s3 cp s3://tayo-wiz/mongodb-org-5.0.repo .
  sudo cp  mongodb-org-5.0.repo /etc/yum.repos.d/mongodb-org-5.0.repo
  sudo yum install -y mongodb-org
  sudo systemctl start mongod
  sudo systemctl status mongod
  sudo systemctl enable mongod
  EOT
  tags = {
    Owner       = "tayoo"
    Team = "mongodb-wiz"
  }
}

resource "aws_security_group" "mongodb_sg" {
  vpc_id = module.vpc.vpc_id
  ingress {
    description      = "22 from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "mongodb_sg"
  }
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "mongodb-server-instance"

  ami                    = var.ami-id
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data_base64       = base64encode(local.user_data)
  iam_instance_profile   = var.aws_iam_instance_profile_name

tags = {
  Terraform   = "true"
  Environment = "dev"
}
}