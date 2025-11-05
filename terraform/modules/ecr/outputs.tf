output "repository_url" {
  value = aws_ecr_repository.demo-ecr.repository_url
}

output "repository_name" {
  value = aws_ecr_repository.demo-ecr.name
}