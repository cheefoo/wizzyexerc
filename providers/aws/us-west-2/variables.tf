
variable "aws_region" {
  description = "The AWS region used to create resources."
  type = string
  default = "us-west-2"
}

variable "instance_type" {
  description = ""
  type = string
  default = "t2.micro"
}

variable "subnet_id" {
  description = ""
  type = string
  default = "subnet-1ff1927a"
}

variable "key_name" {
  description = "ssh key"
  type = string
  default = "favex-ssh"
}

variable "vpc_security_group_ids" {
  description = "vpc_security_group_ids"
  type = list
  default = []
}

variable "ami-id" {
  description = "ami_id."
  type = string
  default = "ami-0ca285d4c2cda3300"
}

variable "aws_iam_instance_profile_name" {
  description = "aws iam instance profile name"
  type = string
  default = "tf_cloud_session"
}

