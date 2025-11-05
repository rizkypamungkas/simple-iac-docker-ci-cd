# Data source: cari AMI Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance
resource "aws_instance" "demo_instance" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.sg_ids
  associate_public_ip_address = true
  key_name                    = "demo-key"
  iam_instance_profile        = var.iam_instance_profile

  tags = {
    Name = var.instance_name
  }

  user_data = <<-EOL
    #!/bin/bash -xe
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu
  EOL
}
