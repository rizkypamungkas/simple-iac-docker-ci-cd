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
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

    apt update -y
    apt upgrade -y
    apt install -y docker.io
    
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ubuntu

    apt install -y unzip curl
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
  EOL
}
