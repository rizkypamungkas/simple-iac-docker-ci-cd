variable "ami_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "sg_ids" {
  type = list(string)
}

variable "instance_name" {
  type = string
}

variable "iam_instance_profile" {
  description = "attach instance profile to ec2 instance"
  type = string
}