output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "instance_id" {
  value = aws_instance.demo_instance.id
}

output "instance_public_ip" {
  value = aws_instance.demo_instance.public_ip
}

output "instance_public_dns" {
  value = aws_instance.demo_instance.public_dns
}

