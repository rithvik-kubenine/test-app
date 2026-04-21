provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project = var.name_prefix
      Stack   = "task-t349-ecs"
    }
  }
}
