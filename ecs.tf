module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "~> 5.12"

  cluster_name = "${var.name_prefix}-cluster"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  tags = {
    Name = "${var.name_prefix}-cluster"
  }
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "~> 5.12"

  name        = "${var.name_prefix}-service"
  cluster_arn = module.ecs_cluster.arn

  cpu    = 256
  memory = 512

  subnet_ids       = module.vpc.public_subnets
  assign_public_ip = true

  security_group_rules = {
    ingress_app = {
      type        = "ingress"
      from_port   = var.container_port
      to_port     = var.container_port
      protocol    = "tcp"
      description = "App port from internet"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  create_task_exec_iam_role = true
  create_task_exec_policy   = true

  create_tasks_iam_role = true

  container_definitions = {
    app = {
      name      = "app"
      essential = true
      image     = var.container_image

      port_mappings = [
        {
          name          = "app"
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      environment               = []
      enable_cloudwatch_logging = true
    }
  }

  desired_count = 1

  tags = {
    Name = "${var.name_prefix}-service"
  }
}
