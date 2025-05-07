################################################################################
##### VPC Example Configuration
################################################################################

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  # 基本设置
  env_prefix                 = var.env_prefix
  aws_region                 = var.aws_region
  
  # VPC CIDR 配置
  vpc_cidr_block             = var.vpc_cidr_block
  secondary_cidr_blocks      = var.secondary_cidr_blocks
  
  # 子网配置
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  aws_azs                    = var.aws_azs
  
  # 功能开关
  enable_nat_gateway         = var.enable_nat_gateway
  single_nat_gateway         = var.single_nat_gateway
  create_vpc_endpoints       = var.create_vpc_endpoints
  
  # 标签
  tags = var.tags
}
