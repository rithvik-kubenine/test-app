# Internet Gateway is attached to the VPC (AWS does not attach an IGW to subnets).
# Public subnets: default route 0.0.0.0/0 -> IGW.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.21"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_cidr

  azs            = var.azs
  public_subnets = [cidrsubnet(var.vpc_cidr, 8, 1), cidrsubnet(var.vpc_cidr, 8, 2)]

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  public_subnet_names = [
    "${var.name_prefix}-public-1",
    "${var.name_prefix}-public-2",
  ]

  vpc_tags = {
    Name = "${var.name_prefix}-vpc"
  }

  igw_tags = {
    Name = "${var.name_prefix}-igw"
  }

  public_subnet_tags = {
    Tier = "public"
  }

  tags = {
    Project = var.name_prefix
  }
}
