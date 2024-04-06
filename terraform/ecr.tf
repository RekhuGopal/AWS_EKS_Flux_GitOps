# Create AWS ECR
module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.6.0"

  repository_name = local.ecr_repo_name

  create_lifecycle_policy         = true
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 untagged images",
        selection = {
          tagStatus   = "untagged",
          countType   = "imageCountMoreThan",
          countNumber = 4
        },
        action = {
          type = "expire"
        }
      },
      {
        "rulePriority" : 2,
        "description" : "Keep last 5 tagged images",
        "selection" : {
          "tagStatus" : "tagged",
          "tagPrefixList" : ["v"],
          "countType" : "imageCountMoreThan",
          "countNumber" : 4
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
  repository_force_delete = true
  depends_on              = [module.vpc]
}
