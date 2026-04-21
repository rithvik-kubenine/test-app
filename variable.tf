variable "aws_region" {
  type        = string
  description = "AWS region for the VPC."
  default     = "ap-south-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile."
  default     = "rithvik-kubenine"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for VPC and subnet names."
  default     = "rithvik-task-349"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC IPv4 CIDR (use a non-overlapping range if other VPCs exist in the account)."
  default     = "10.1.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Two availability zones; public and private /24 subnets are created one pair per AZ."
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "container_image" {
  type        = string
  description = "Container image for the ECS service."
  default     = "idli12atkube9/test-app:latest"
}

variable "container_port" {
  type        = number
  description = "Port the Flask app listens on."
  default     = 5000
}

variable "github_repository" {
  type        = string
  description = "GitHub repository allowed to assume the OIDC role (format: owner/repo)."
  default     = "idli12atkube9/tform"
}

variable "github_branch" {
  type        = string
  description = "Git branch allowed to assume the OIDC role."
  default     = "main"
}

variable "github_actions_role_policy_arns" {
  type        = list(string)
  description = "Managed IAM policy ARNs to attach to the GitHub Actions role."
  default     = []
}
