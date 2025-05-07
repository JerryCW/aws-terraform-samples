################################################################################
# 主配置文件
# 调用VPC模块创建网络基础设施
################################################################################

module "vpc" {
  source = "./modules/networking/vpc"

  # 环境变量
  env_prefix  = var.env_prefix
  common_tags = var.common_tags
  aws_region  = var.aws_region

  # VPC配置
  vpc_cidr_block        = var.vpc_cidr_block
  secondary_cidr_blocks = var.secondary_cidr_blocks
  aws_azs               = var.aws_azs

  # 子网配置
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks

  # 网关配置
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  enable_internet_gateway = var.enable_internet_gateway

  # VPC端点配置
  vpc_endpoints = var.vpc_endpoints
}
