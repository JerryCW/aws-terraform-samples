################################################################################
##### VPC
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.17"

  cidr                  = var.vpc_cidr_block
  secondary_cidr_blocks = var.secondary_cidr_blocks
  azs                   = var.aws_azs
  private_subnets       = var.private_subnet_cidr_blocks
  public_subnets        = var.public_subnet_cidr_blocks

  # 配置公有子网的Tag
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  # 动态生成公有子网的AZ标签，基于提供的可用区列表
  public_subnet_tags_per_az = {
    for az in var.aws_azs : az => {
      Name = "${var.env_prefix}-${az}-public-subnet"
    }
  }

  # 配置私有子网的Tag
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  # 动态生成私有子网的AZ标签，基于提供的可用区列表
  private_subnet_tags_per_az = {
    for az in var.aws_azs : az => {
      Name = "${var.env_prefix}-${az}-private-subnet"
    }
  }

  default_route_table_tags = {
    Name = "${var.env_prefix}-rtb-default"
  }

  public_route_table_tags = {
    Name = "${var.env_prefix}-rtb-public"
  }

  private_route_table_tags = {
    Name = "${var.env_prefix}-rtb-private"
  }

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  nat_gateway_tags   = {
    Name = "${var.env_prefix}-nat"
  }

  create_igw = true
  igw_tags   = {
    Name = "${var.env_prefix}-igw"
  }

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.env_prefix}-vpc"
    }
  )
}
