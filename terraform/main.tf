provider "aws" {
  region = "ap-southeast-1"
}


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

module "networking" {
  source             = "./modules/networking"  
}

module "iam" {
  source = "./modules/iam"
}

module "compute" {
  source                = "./modules/compute"
  ami_id                = data.aws_ami.ubuntu.id
  subnet_id             = module.networking.subnet_id
  sg_ids                = [module.networking.sg_id]
  iam_instance_profile  = module.iam.instance_profile_name
  instance_name         = "demo-instance"

}

module "ecr" {
  source = "./modules/ecr"
}