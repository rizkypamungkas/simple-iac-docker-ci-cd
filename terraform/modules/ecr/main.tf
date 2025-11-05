resource "aws_ecr_repository" "demo-ecr" {
  name = "ecr-ci-cd"
  
  image_tag_mutability = "IMMUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "demo_ecr_policy" {
  repository = aws_ecr_repository.demo-ecr.name

    policy = jsonencode({
      rules = [{
        rulePriority = 1
        description  = "Expire untagged images after 30 days"
        selection = {
          tagStatus    = "untagged"
          countType    = "sinceImagePushed"
          countUnit    = "days"
          countNumber  = 30
        }
        action = {
          type = "expire"
        }
      }]
    })
  }

