# One OIDC provider per account for GitHub (URL token.actions.githubusercontent.com).
# If it already exists (another stack or console), we reference it instead of creating it.

data "aws_caller_identity" "current" {}

data "aws_iam_openid_connect_provider" "github_actions" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

# Trust policy shape (rendered by Terraform; <OIDC_ARN> is
# arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com):
#
# {
#   "Version": "2012-10-17",
#   "Statement": [{
#     "Effect": "Allow",
#     "Principal": { "Federated": "<OIDC_ARN>" },
#     "Action": "sts:AssumeRoleWithWebIdentity",
#     "Condition": {
#       "StringEquals": {
#         "token.actions.githubusercontent.com:sub": "repo:<owner>/<repo>:ref:refs/heads/<branch>",
#         "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
#       }
#     }
#   }]
# }
#
# :aud matches the audience GitHub sends; AWS recommends scoping both :sub and :aud.

locals {
  github_oidc_sub = "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.github_oidc_sub]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "${var.name_prefix}-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = {
    Name = "${var.name_prefix}-github-actions-role"
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_managed" {
  for_each = toset(var.github_actions_role_policy_arns)

  role       = aws_iam_role.github_actions.name
  policy_arn = each.value
}

data "aws_iam_policy_document" "github_actions_ecs_deploy" {
  count = var.github_actions_attach_ecs_deploy_policy ? 1 : 0

  # Service ARN (e.g. ...:service/cluster-name/service-name) — known after ECS service exists.
  statement {
    sid = "ECSUpdateDescribeThisServiceOnly"
    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices",
    ]
    resources = [module.ecs_service.id]
  }
}

resource "aws_iam_role_policy" "github_actions_ecs_deploy" {
  count = var.github_actions_attach_ecs_deploy_policy ? 1 : 0

  name   = "${var.name_prefix}-github-actions-ecs-service"
  role   = aws_iam_role.github_actions.name
  policy = data.aws_iam_policy_document.github_actions_ecs_deploy[0].json
}
